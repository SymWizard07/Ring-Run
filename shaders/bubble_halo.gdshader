shader_type canvas_item;

uniform vec4 bubble_color : source_color = vec4(1.0, 0.88, 0.45, 1.0);
uniform float edge_strength : hint_range(0.1, 8.0) = 2.5;
uniform float alpha_strength : hint_range(0.0, 1.0) = 0.45;
uniform float highlight_strength : hint_range(0.0, 1.0) = 0.35;
uniform vec2 highlight_offset = vec2(-0.22, -0.22);
uniform float highlight_size : hint_range(0.01, 1.0) = 0.22;

void fragment() {
    // UV centered so middle of sprite is (0,0)
    vec2 p = UV - vec2(0.5);
    
    // Correct for non-square textures so the bubble stays circular
    vec2 aspect = vec2(TEXTURE_PIXEL_SIZE.y / TEXTURE_PIXEL_SIZE.x, 1.0);
    vec2 q = p * aspect;

    float dist = length(q) * 2.0; // ~0 at center, ~1 at edge

    // Circular mask
    float bubble_mask = 1.0 - smoothstep(0.98, 1.0, dist);

    // Stronger color near edges, fading into center
    float rim = pow(clamp(dist, 0.0, 1.0), edge_strength);

    // Soft alpha, also stronger near edges
    float alpha = rim * alpha_strength * bubble_mask;

    // Specular-style highlight
    vec2 hp = q - highlight_offset;
    float highlight = 1.0 - smoothstep(highlight_size * 0.6, highlight_size, length(hp));
    highlight *= highlight_strength * bubble_mask;

    vec3 color = bubble_color.rgb * rim + vec3(1.0) * highlight;

    COLOR = vec4(color, alpha + highlight * 0.25);
}