shader_type canvas_item;


uniform int shape_type = 0;
uniform vec2 rect_size = vec2(150.0, 100.0);


uniform vec2 mouse_pos;
uniform float radius = 100.0;           // Rayon du cercle
uniform float softness = 30.0;          // Bord flou
uniform float wave_strength = 11.0;      // Amplitude de la distorsion de l'eau
uniform float wave_frequency = 1;     // Fréquence des vagues
uniform float noise_scale = 0.5;       // Échelle du bruit (influence sur la distorsion)
uniform vec4 front_color : source_color; // Couleur du front (souvent blanc ou noir)

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;


// Circle reveal
float mask_circle(vec2 pos, float r, float s) {
    float dist = length(pos);
    return smoothstep(r, r + s, dist);
}

// Rectangle reveal
float mask_rect(vec2 pos, vec2 half_size, float s) {
    vec2 d = abs(pos) - half_size; // distance outside rectangle
    float outside = length(max(d, 0.0));
    return smoothstep(0.0, s, outside);
}

// Ellipse reveal
float mask_ellipse(vec2 pos, vec2 half_size, float s) {
    vec2 norm_pos = pos / half_size;
    float dist = length(norm_pos);
    return smoothstep(1.0, 1.0 + s / max(half_size.x, half_size.y), dist);
}

// Improved random function for more variation
float rand(vec2 co) {
    return fract(sin(dot(co.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

// Blurry, random wave effect
vec2 wave_effect(vec2 pos) {
    float t = TIME * 2.0;
    float n1 = rand(floor(pos * noise_scale + t));
    float n2 = rand(floor(pos.yx * noise_scale - t));
    float n3 = rand(floor(pos * noise_scale * 1.5 + t * 0.5));
    float wave_x = sin(pos.x * wave_frequency + t + n1 * 6.28) * wave_strength * (0.5 + n2);
    float wave_y = cos(pos.y * wave_frequency + t + n3 * 6.28) * wave_strength * (0.5 + n1);
    // Blur by mixing several offsets
    vec2 offset1 = vec2(wave_x, wave_y) * 0.5;
    vec2 offset2 = vec2(
        sin(pos.y * wave_frequency + t + n2 * 3.14) * wave_strength * 0.3,
        cos(pos.x * wave_frequency + t + n3 * 3.14) * wave_strength * 0.3
    );
    vec2 offset3 = vec2(
        sin(pos.x * wave_frequency * 0.7 + t + n3 * 2.0) * wave_strength * 0.2,
        cos(pos.y * wave_frequency * 0.7 + t + n1 * 2.0) * wave_strength * 0.2
    );
    return pos + offset1 + offset2 + offset3;
}

void fragment() {
    vec2 pixel_pos = UV * vec2(textureSize(SCREEN_TEXTURE, 0));
    vec2 relative_pos = pixel_pos - mouse_pos;

    // Appliquer la distorsion aquatique à la position des pixels
    vec2 distorted_pos = wave_effect(relative_pos);

    float dist = length(distorted_pos); // Distance par rapport au centre du cercle

    // Création d'une transition douce autour du rayon
    float alpha = smoothstep(radius, radius + softness, dist);
		if (shape_type == 0) { // Circle
    alpha = mask_circle(distorted_pos, radius, softness);
} else if (shape_type == 1) { // Rectangle
    alpha = mask_rect(distorted_pos, rect_size, softness);
} else if (shape_type == 2) { // Ellipse
    alpha = mask_ellipse(distorted_pos, rect_size, softness);
}
    COLOR = front_color;
    COLOR.a *= alpha; // Appliquer la transparence avec l'alpha
}




