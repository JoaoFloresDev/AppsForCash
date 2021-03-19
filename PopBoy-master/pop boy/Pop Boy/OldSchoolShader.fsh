void main( void )
{
    float deltaX = sin(v_tex_coord.y*3.14*10 + u_time * 4)*0.01;
    vec2 coord = v_tex_coord;
    coord.x = coord.x + deltaX;
    vec4 color = texture2D(u_texture, coord);
    gl_FragColor = color;
}
