shader_type spatial;
render_mode unshaded, cull_disabled, depth_draw_opaque;



uniform vec4 color = vec4(0.738, 0.109, 0.032, 0.3);
uniform float speed = 2.0;             // pulsation speed
uniform float border_thickness = 0.15; // outline width
uniform float scale_min = 0.25;
uniform float scale_max = 0.5;

float rect_outline(vec2 uv, float size, float width) {
    // uv centered
    uv = abs(uv);
    float outer = max(uv.x, uv.y) - size;
    float inner = max(uv.x, uv.y) - (size - width);
    return smoothstep(0.0, 0.01, -outer) * (1.0 - smoothstep(0.0, 0.01, -inner));
}

void fragment() {
    vec2 uv = (UV - 0.5) * 2.0;

    float t = sin(TIME * speed) * 0.5 + 0.5;
    float size = mix(scale_min, scale_max, t);

    float outline = rect_outline(uv, size, border_thickness);

    ALBEDO = color.rgb;
    ALPHA = outline * color.a;
}
