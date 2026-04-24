/**
 * JwtAuthFilter.java — API Gateway JWT Authentication Filter
 *
 * This filter runs on EVERY request that passes through the API Gateway.
 * It is the FIRST line of security for the entire application.
 *
 * Responsibilities:
 *   1. Check if the request path is public (no token needed)
 *   2. Validate the JWT token from the Authorization header
 *   3. Allow internal service-to-service calls
 *   4. Forward user info (email, role) to downstream services as headers
 *   5. Return 401 Unauthorized for invalid/missing tokens
 *
 * This is a Spring Cloud Gateway filter (reactive/non-blocking).
 * Different from Spring MVC filters — uses Mono/Flux (Project Reactor).
 *
 * AbstractGatewayFilterFactory — base class for custom gateway filters
 * Config — inner class for filter configuration (empty in our case)
 */

package com.connectsphere.gateway;

import io.jsonwebtoken.Claims;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.cloud.gateway.filter.GatewayFilter;
import org.springframework.cloud.gateway.filter.factory.AbstractGatewayFilterFactory;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;
import org.springframework.web.server.ServerWebExchange;
import reactor.core.publisher.Mono;
import java.util.List;

@Component
public class JwtAuthFilter extends AbstractGatewayFilterFactory<JwtAuthFilter.Config> {

    /** jwtUtil — validates tokens and extracts claims */
    private final JwtUtil jwtUtil;

    /** internalToken — special token for service-to-service calls */
    @Value("${service.internal.token:internal-service-token}")
    private String internalToken;

    public JwtAuthFilter(JwtUtil jwtUtil) {
        super(Config.class);
        this.jwtUtil = jwtUtil;
    }

    /**
     * PUBLIC_PATHS — List of URL paths that don't require authentication
     *
     * Any request whose path CONTAINS one of these strings is allowed through.
     * Uses .contains() check — so "/auth/login" matches "/auth/login" path.
     *
     * Why these paths are public:
     *   /auth/register, /auth/login, /auth/guest — users need to authenticate first
     *   /auth/forgot-password, /auth/reset-password — password reset flow
     *   /auth/user/ — viewing user profiles (public info)
     *   /posts/feed, /posts/search, /posts/user/ — public post browsing
     *   /comments/post/ — viewing comments (public)
     *   /likes/summary, /likes/ — viewing reaction counts (public)
     *   /follows/ — viewing follow relationships (public)
     *   /search, /hashtags/ — search and trending (public)
     *   /media/files/ — serving uploaded images/videos (must be public)
     *   /actuator — Spring Boot health check endpoint
     */
    private static final List<String> PUBLIC_PATHS = List.of(
        "/auth/register",
        "/auth/login",
        "/auth/guest",
        "/auth/forgot-password",
        "/auth/reset-password",
        "/auth/user/",
        "/auth/search",
        "/oauth2/",
        "/login/oauth2/",
        "/posts/feed",
        "/posts/search",
        "/posts/user/",
        "/posts/",
        "/comments/post/",
        "/comments/",
        "/likes/summary",
        "/likes/",
        "/follows/",
        "/search",
        "/hashtags/",
        "/media/files/",
        "/actuator"
    );

    /**
     * apply() — Creates the actual filter logic
     *
     * Returns a GatewayFilter (lambda function) that:
     *   1. Gets the request path
     *   2. If public path → pass through without checking token
     *   3. Get Authorization header
     *   4. If no header or wrong format → return 401
     *   5. Extract token from "Bearer <token>"
     *   6. If internal service token → pass through
     *   7. Validate JWT token → if invalid → return 401
     *   8. Extract email and role from token
     *   9. Add X-User-Email and X-User-Role headers to forwarded request
     *   10. Pass to next filter/service
     *
     * exchange — represents the HTTP request/response
     * chain — the filter chain (call chain.filter to continue)
     * Mono<Void> — reactive return type (non-blocking)
     */
    @Override
    public GatewayFilter apply(Config config) {
        return (exchange, chain) -> {
            String path = exchange.getRequest().getURI().getPath();

            /* Step 1: Allow public paths without token */
            if (isPublic(path)) {
                return chain.filter(exchange);
            }

            /* Step 2: Get Authorization header */
            String authHeader = exchange.getRequest()
                .getHeaders().getFirst(HttpHeaders.AUTHORIZATION);

            /* Step 3: Reject if no token or wrong format */
            if (authHeader == null || !authHeader.startsWith("Bearer ")) {
                return unauthorized(exchange);
            }

            /* Step 4: Extract token (remove "Bearer " prefix) */
            String token = authHeader.substring(7);

            /* Step 5: Allow internal service-to-service calls */
            if (token.equals(internalToken)) {
                return chain.filter(exchange);
            }

            /* Step 6: Validate JWT token */
            if (!jwtUtil.isValid(token)) {
                return unauthorized(exchange);
            }

            /* Step 7: Extract user info and forward as headers */
            try {
                Claims claims = jwtUtil.getClaims(token);
                String role = claims.get("role", String.class);

                /*
                 * Mutate the request to add user info headers
                 * Downstream services (auth-service, post-service etc.) can read:
                 *   X-User-Email — the authenticated user's email
                 *   X-User-Role  — the user's role (USER/ADMIN/GUEST)
                 *
                 * exchange.mutate() — creates a modified copy of the exchange
                 * .request(r -> r.header(...)) — adds headers to the request
                 */
                ServerWebExchange mutated = exchange.mutate()
                    .request(r -> r
                        .header("X-User-Email", claims.getSubject())
                        .header("X-User-Role", role != null ? role : "USER"))
                    .build();

                return chain.filter(mutated);
            } catch (Exception e) {
                return unauthorized(exchange);
            }
        };
    }

    /**
     * isPublic() — Checks if a path is in the public paths list
     *
     * PUBLIC_PATHS.stream().anyMatch(path::contains)
     * Checks if the request path CONTAINS any of the public path strings
     * e.g. path "/posts/feed" contains "/posts/feed" → public
     * e.g. path "/posts/5" contains "/posts/" → public
     */
    private boolean isPublic(String path) {
        return PUBLIC_PATHS.stream().anyMatch(path::contains);
    }

    /**
     * unauthorized() — Returns 401 Unauthorized response
     *
     * Sets HTTP status to 401
     * exchange.getResponse().setComplete() — ends the response (no body)
     * Returns Mono<Void> — reactive empty response
     */
    private Mono<Void> unauthorized(ServerWebExchange exchange) {
        exchange.getResponse().setStatusCode(HttpStatus.UNAUTHORIZED);
        return exchange.getResponse().setComplete();
    }

    /**
     * Config — Empty configuration class required by AbstractGatewayFilterFactory
     * Could be used to pass configuration parameters to the filter
     * Currently not used but required by the framework
     */
    public static class Config {}
}
