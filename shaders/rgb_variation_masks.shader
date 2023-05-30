
HEADER
{
	Description = "";
}

FEATURES
{
	#include "vr_common_features.fxc"
	Feature( F_ADDITIVE_BLEND, 0..1, "Blending" );
}

COMMON
{
	#ifndef S_ALPHA_TEST
	#define S_ALPHA_TEST 0
	#endif
	#ifndef S_TRANSLUCENT
	#define S_TRANSLUCENT 0
	#endif
	
	#include "common/shared.hlsl"

	#define S_UV2 1
}

struct VertexInput
{
	#include "common/vertexinput.hlsl"
};

struct PixelInput
{
	#include "common/pixelinput.hlsl"
	float3 vPositionOs : TEXCOORD14;
};

VS
{
	#include "common/vertex.hlsl"

	PixelInput MainVs( VertexInput i )
	{
		PixelInput o = ProcessVertex( i );
		o.vPositionOs = i.vPositionOs.xyz;
		return FinalizeVertex( o );
	}
}

PS
{
	#include "sbox_pixel.fxc"
	#include "common/pixel.material.structs.hlsl"
	#include "common/pixel.lighting.hlsl"
	#include "common/pixel.shading.hlsl"
	#include "common/pixel.material.helpers.hlsl"
	#include "common/pixel.color.blending.hlsl"
	#include "common/proceedural.hlsl"
	
	SamplerState g_sSampler0 <
	 Filter( ANISO ); AddressU( WRAP ); AddressV( WRAP ); >;CreateInputTexture2D( GlobalAlbedo, Srgb, 8,
	 "None", "_color", "Base Textures,0/,0/0", Default4( 1.00, 1.00, 1.00, 1.00 ) );CreateInputTexture2D( RedAlbedo, Srgb, 8,
	 "None", "_color", "Red Channel,0/,0/0", Default4( 1.00, 1.00, 1.00, 1.00 ) );CreateInputTexture2D( RGBVariationMask, Linear, 8,
	 "None", "_mask", "Unique Textures,0/,0/0", Default4( 1.00, 1.00, 1.00, 1.00 ) );CreateInputTexture2D( GreenAlbedo, Srgb, 8,
	 "None", "_color", "Green Channel,0/,0/0", Default4( 1.00, 1.00, 1.00, 1.00 ) );CreateInputTexture2D( BlueAlbedo, Srgb, 8,
	 "None", "_color", "Blue Channel,0/,0/0", Default4( 1.00, 1.00, 1.00, 1.00 ) );CreateInputTexture2D( GlobalNormal, Linear, 8,
	 "NormalizeNormals", "_normal", "Base Textures,0/,0/0", Default4( 1.00, 1.00, 1.00, 1.00 ) );CreateInputTexture2D( RedNormal, Linear, 8,
	 "NormalizeNormals", "_normal", "Red Channel,0/,0/0", Default4( 1.00, 1.00, 1.00, 1.00 ) );CreateInputTexture2D( GreenNormal, Linear, 8,
	 "NormalizeNormals", "_normal", "Green Channel,0/,0/0", Default4( 1.00, 1.00, 1.00, 1.00 ) );CreateInputTexture2D( BlueNormal, Linear, 8,
	 "NormalizeNormals", "_normal", "Blue Channel,0/,0/0", Default4( 1.00, 1.00, 1.00, 1.00 ) );CreateInputTexture2D( GlobalRoughness, Linear, 8,
	 "None", "_rough", "Base Textures,0/,0/0", Default4( 1.00, 1.00, 1.00, 1.00 ) );CreateInputTexture2D( RedRoughness, Linear, 8,
	 "None", "_rough", "Red Channel,0/,0/0", Default4( 1.00, 1.00, 1.00, 1.00 ) );CreateInputTexture2D( GreenRoughness, Linear, 8,
	 "None", "_rough", "Green Channel,0/,0/0", Default4( 1.00, 1.00, 1.00, 1.00 ) );CreateInputTexture2D( BlueRoughness, Linear, 8,
	 "None", "_rough", "Blue Channel,0/,0/0", Default4( 1.00, 1.00, 1.00, 1.00 ) );CreateInputTexture2D( GlobalMetallic, Linear, 8,
	 "None", "_rough", "Base Textures,0/,0/0", Default4( 0.00, 0.00, 0.00, 1.00 ) );CreateInputTexture2D( RedMetallic, Linear, 8,
	 "None", "_rough", "Red Channel,0/,0/0", Default4( 0.00, 0.00, 0.00, 1.00 ) );CreateInputTexture2D( GreenMetallic, Linear, 8,
	 "None", "_rough", "Green Channel,0/,0/0", Default4( 0.00, 0.00, 0.00, 1.00 ) );CreateInputTexture2D( BlueMetallic, Linear, 8,
	 "None", "_rough", "Blue Channel,0/,0/0", Default4( 0.00, 0.00, 0.00, 1.00 ) );Texture2D g_tGlobalAlbedo < Channel( RGBA, Box( GlobalAlbedo ), Srgb );
	 OutputFormat( DXT5 ); SrgbRead( True ); >;Texture2D g_tRedAlbedo < Channel( RGBA, Box( RedAlbedo ), Srgb );
	 OutputFormat( DXT5 ); SrgbRead( True ); >;Texture2D g_tRGBVariationMask < Channel( RGBA, Box( RGBVariationMask ), Linear );
	 OutputFormat( DXT5 ); SrgbRead( False ); >;Texture2D g_tGreenAlbedo < Channel( RGBA, Box( GreenAlbedo ), Srgb );
	 OutputFormat( DXT5 ); SrgbRead( True ); >;Texture2D g_tBlueAlbedo < Channel( RGBA, Box( BlueAlbedo ), Srgb );
	 OutputFormat( DXT5 ); SrgbRead( True ); >;Texture2D g_tGlobalNormal < Channel( RGBA, Box( GlobalNormal ), Linear );
	 OutputFormat( DXT5 ); SrgbRead( False ); >;Texture2D g_tRedNormal < Channel( RGBA, Box( RedNormal ), Linear );
	 OutputFormat( DXT5 ); SrgbRead( False ); >;Texture2D g_tGreenNormal < Channel( RGBA, Box( GreenNormal ), Linear );
	 OutputFormat( DXT5 ); SrgbRead( False ); >;Texture2D g_tBlueNormal < Channel( RGBA, Box( BlueNormal ), Linear );
	 OutputFormat( DXT5 ); SrgbRead( False ); >;Texture2D g_tGlobalRoughness < Channel( RGBA, Box( GlobalRoughness ), Linear );
	 OutputFormat( DXT5 ); SrgbRead( False ); >;Texture2D g_tRedRoughness < Channel( RGBA, Box( RedRoughness ), Linear );
	 OutputFormat( DXT5 ); SrgbRead( False ); >;Texture2D g_tGreenRoughness < Channel( RGBA, Box( GreenRoughness ), Linear );
	 OutputFormat( DXT5 ); SrgbRead( False ); >;Texture2D g_tBlueRoughness < Channel( RGBA, Box( BlueRoughness ), Linear );
	 OutputFormat( DXT5 ); SrgbRead( False ); >;Texture2D g_tGlobalMetallic < Channel( RGBA, Box( GlobalMetallic ), Linear );
	 OutputFormat( DXT5 ); SrgbRead( False ); >;Texture2D g_tRedMetallic < Channel( RGBA, Box( RedMetallic ), Linear );
	 OutputFormat( DXT5 ); SrgbRead( False ); >;Texture2D g_tGreenMetallic < Channel( RGBA, Box( GreenMetallic ), Linear );
	 OutputFormat( DXT5 ); SrgbRead( False ); >;Texture2D g_tBlueMetallic < Channel( RGBA, Box( BlueMetallic ), Linear );
	 OutputFormat( DXT5 ); SrgbRead( False ); >;float4 g_vRedTint < UiType( Color ); UiGroup( "Red Channel,0/,0/0" ); Default4( 1.00, 1.00, 1.00, 1.00 ); >;
	float g_flRedMaskStrength < UiGroup( "Red Channel,0/,0/0" ); Default1( 1 ); Range1( 0, 10 ); >;
	float4 g_vGreenTint < UiType( Color ); UiGroup( "Green Channel,0/,0/0" ); Default4( 1.00, 1.00, 1.00, 1.00 ); >;
	float g_flGreenMaskStrength < UiGroup( "Green Channel,0/,0/0" ); Default1( 1 ); Range1( 0, 10 ); >;
	float4 g_vBlueTint < UiType( Color ); UiGroup( "Blue Channel,0/,0/0" ); Default4( 1.00, 1.00, 1.00, 1.00 ); >;
	float g_flBlueMaskStrength < UiGroup( "Blue Channel,0/,0/0" ); Default1( 3.076231 ); Range1( 0, 10 ); >;
	
	float4 MainPs( PixelInput i ) : SV_Target0
	{
		Material m;
		m.Albedo = float3( 1, 1, 1 );
		m.Normal = TransformNormal( i, float3( 0, 0, 1 ) );
		m.Roughness = 1;
		m.Metalness = 0;
		m.AmbientOcclusion = 1;
		m.TintMask = 1;
		m.Opacity = 1;
		m.Emission = float3( 0, 0, 0 );
		m.Transmission = 0;
		
		float4 local0 = Tex2DS( g_tGlobalAlbedo, g_sSampler0, i.vTextureCoords.xy );
		float4 local1 = Tex2DS( g_tRedAlbedo, g_sSampler0, i.vTextureCoords.xy );
		float4 local2 = g_vRedTint;
		float4 local3 = local1 * local2;
		float4 local4 = Tex2DS( g_tRGBVariationMask, g_sSampler0, i.vTextureCoords.xy );
		float local5 = g_flRedMaskStrength;
		float local6 = local4.r * local5;
		float local7 = saturate( local6 );
		float4 local8 = lerp( local0, local3, local7 );
		float4 local9 = Tex2DS( g_tGreenAlbedo, g_sSampler0, i.vTextureCoords.xy );
		float4 local10 = g_vGreenTint;
		float4 local11 = local9 * local10;
		float local12 = g_flGreenMaskStrength;
		float local13 = local4.g * local12;
		float local14 = saturate( local13 );
		float4 local15 = lerp( local8, local11, local14 );
		float4 local16 = Tex2DS( g_tBlueAlbedo, g_sSampler0, i.vTextureCoords.xy );
		float4 local17 = g_vBlueTint;
		float4 local18 = local16 * local17;
		float local19 = g_flBlueMaskStrength;
		float local20 = local4.b * local19;
		float local21 = saturate( local20 );
		float4 local22 = lerp( local15, local18, local21 );
		float4 local23 = Tex2DS( g_tGlobalNormal, g_sSampler0, i.vTextureCoords.xy );
		float4 local24 = Tex2DS( g_tRedNormal, g_sSampler0, i.vTextureCoords.xy );
		float local25 = saturate( local6 );
		float4 local26 = saturate( lerp( local23, Overlay_blend( local23, local24 ), local25 ) );
		float4 local27 = Tex2DS( g_tGreenNormal, g_sSampler0, i.vTextureCoords.xy );
		float local28 = saturate( local13 );
		float4 local29 = saturate( lerp( local26, Overlay_blend( local26, local27 ), local28 ) );
		float4 local30 = Tex2DS( g_tBlueNormal, g_sSampler0, i.vTextureCoords.xy );
		float local31 = saturate( local20 );
		float4 local32 = saturate( lerp( local29, Overlay_blend( local29, local30 ), local31 ) );
		float3 local33 = TransformNormal( i, DecodeNormal( local32.xyz ) );
		float4 local34 = Tex2DS( g_tGlobalRoughness, g_sSampler0, i.vTextureCoords.xy );
		float4 local35 = Tex2DS( g_tRedRoughness, g_sSampler0, i.vTextureCoords.xy );
		float local36 = saturate( local6 );
		float4 local37 = lerp( local34, local35, local36 );
		float4 local38 = Tex2DS( g_tGreenRoughness, g_sSampler0, i.vTextureCoords.xy );
		float local39 = saturate( local13 );
		float4 local40 = lerp( local37, local38, local39 );
		float4 local41 = Tex2DS( g_tBlueRoughness, g_sSampler0, i.vTextureCoords.xy );
		float local42 = saturate( local20 );
		float4 local43 = lerp( local40, local41, local42 );
		float4 local44 = Tex2DS( g_tGlobalMetallic, g_sSampler0, i.vTextureCoords.xy );
		float4 local45 = Tex2DS( g_tRedMetallic, g_sSampler0, i.vTextureCoords.xy );
		float local46 = saturate( local6 );
		float4 local47 = lerp( local44, local45, local46 );
		float4 local48 = Tex2DS( g_tGreenMetallic, g_sSampler0, i.vTextureCoords.xy );
		float local49 = saturate( local13 );
		float4 local50 = lerp( local47, local48, local49 );
		float4 local51 = Tex2DS( g_tBlueMetallic, g_sSampler0, i.vTextureCoords.xy );
		float local52 = saturate( local20 );
		float4 local53 = lerp( local50, local51, local52 );
		
		m.Albedo = local22.xyz;
		m.Opacity = 1;
		m.Normal = local33;
		m.Roughness = local43.x;
		m.Metalness = local53.x;
		m.AmbientOcclusion = 1;
		
		m.AmbientOcclusion = saturate( m.AmbientOcclusion );
		m.Roughness = saturate( m.Roughness );
		m.Metalness = saturate( m.Metalness );
		m.Opacity = saturate( m.Opacity );
		
		ShadingModelValveStandard sm;
		return FinalizePixelMaterial( i, m, sm );
	}
}
