shader_type canvas_item;

uniform float time : hint_range(0, 10);
uniform float wave_speed : hint_range(0.0, 1.0) = 0.1;
uniform float wave_strength : hint_range(0.0, 0.1) = 0.03;

void vertex() {
    // Añadir desplazamiento en la coordenada UV para crear el efecto de las ondas.
    UV.x += sin(UV.y * 10.0 + time * wave_speed) * wave_strength;
    UV.y += cos(UV.x * 10.0 + time * wave_speed) * wave_strength;
}

void fragment() {
    // Obtener el color de la textura base
    vec4 pixelColor = texture(TEXTURE, UV);
    
    // Modificar el color para que tenga un tono más acuoso
    pixelColor.rgb *= vec3(0.3, 0.5, 0.7);  // Cambia la tonalidad a algo más azul
    
    // Aplicar un poco de transparencia para imitar el agua
    pixelColor.a *= 0.6;
    
    COLOR = pixelColor;
}
