shader_type canvas_item;

uniform vec2 hole_uv_pos = vec2(0.3, 0.3);
uniform vec2 hole_uv_size = vec2(0.3, 0.3);
uniform float dim_alpha = 0.6; // quanto scuro è il resto

void fragment() {
    vec4 col = COLOR;

    bool in_hole = UV.x > hole_uv_pos.x &&
                   UV.x < hole_uv_pos.x + hole_uv_size.x &&
                   UV.y > hole_uv_pos.y &&
                   UV.y < hole_uv_pos.y + hole_uv_size.y;

    if (in_hole) {
        // zona del “buco” → trasparente
        col.a = 0.0;
    } else {
        // resto dello schermo scurito
        col.a = dim_alpha;
    }

    COLOR = col;
}