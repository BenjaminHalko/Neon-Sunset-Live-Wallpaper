varying vec4 v_TexCoord;
varying vec4 v_Vars;
varying vec3 v_Position;

uniform vec3 g_ColorGridNear; // {"material":"gridnear","default":"1 0 0.2","type":"color"}
uniform vec3 g_ColorGridFar; // {"material":"gridfar","default":"0 0 1","type":"color"}
uniform vec3 g_ColorGridBackground; // {"material":"gridbackground","default":"0.1 0 0.1","type":"color"}
uniform float g_ShadingAmount; // {"material":"shading","default":"1"}

void main() {
	vec3 pos = v_Position;
	
	vec3 dx = dFdx(pos);
	vec3 dy = dFdy(pos);
	vec3 n = normalize(cross(dy, dx));
	vec3 lightDir = normalize(vec3(0.0, -0.15, -2.0) - pos);

	vec2 grid = abs(fract(v_TexCoord.zw) - 0.5);
	vec2 gridBlend = smoothstep(v_Vars.yz, vec2(0.5), grid);
	float gridAlpha = gridBlend.x + gridBlend.y;
	
	gridBlend = smoothstep(vec2(0.0), vec2(1.0), grid);
	gridAlpha += (gridBlend.x + gridBlend.y) * clamp(0.3 - v_TexCoord.y, 0.0, 1.0);
	
	float alphaDistanceFade = smoothstep(1.0, 0.9, v_Vars.x);
	
	vec3 colorNear = g_ColorGridNear;
	vec3 colorFar = g_ColorGridFar;
	float colorDistanceBlend = pow(v_TexCoord.y, 0.8);
	
	float shadingNear = dot(vec3(0.0, 0.0, 1.0), n);
	float shadingFar = dot(lightDir, n);
	vec3 shadingColor = clamp(shadingNear, 0.0, 1.0) * g_ColorGridNear * (1.0 - colorDistanceBlend)
						+ clamp(shadingFar, 0.0, 1.0) * g_ColorGridFar;
	vec3 colorGrid = g_ColorGridBackground + shadingColor * g_ShadingAmount;
	
	vec3 resultColor = mix(colorGrid,
						mix(colorNear, colorFar, colorDistanceBlend),
						gridAlpha * alphaDistanceFade);

	gl_FragColor = vec4(resultColor, alphaDistanceFade);
}
