
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
	#define CUSTOM_MATERIAL_INPUTS
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
	#include "common/pixel.hlsl"
	#include "procedural.hlsl"
	#include "blendmodes.hlsl"
	
	SamplerState g_sSampler0 < Filter( ANISO ); AddressU( WRAP ); AddressV( WRAP ); >;
	CreateInputTexture2D( GlobalAlbedo, Srgb, 8, "None", "_color", "Base Textures,1/,0/0", Default4( 1.00, 1.00, 1.00, 1.00 ) );
	CreateInputTexture2D( RedAlbedo, Srgb, 8, "None", "_color", "Red Channel,2/,0/0", Default4( 1.00, 1.00, 1.00, 1.00 ) );
	CreateInputTexture2D( RGBVariationMask, Linear, 8, "None", "_mask", "Unique Textures,0/,0/0", Default4( 1.00, 1.00, 1.00, 1.00 ) );
	CreateInputTexture2D( GreenAlbedo, Srgb, 8, "None", "_color", "Green Channel,3/,0/0", Default4( 1.00, 1.00, 1.00, 1.00 ) );
	CreateInputTexture2D( BlueAlbedo, Srgb, 8, "None", "_color", "Blue Channel,4/,0/0", Default4( 1.00, 1.00, 1.00, 1.00 ) );
	CreateInputTexture2D( GlobalNormal, Linear, 8, "NormalizeNormals", "_normal", "Base Textures,1/,0/0", Default4( 1.00, 1.00, 1.00, 1.00 ) );
	CreateInputTexture2D( RedNormal, Linear, 8, "NormalizeNormals", "_normal", "Red Channel,2/,0/0", Default4( 1.00, 1.00, 1.00, 1.00 ) );
	CreateInputTexture2D( GreenNormal, Linear, 8, "NormalizeNormals", "_normal", "Green Channel,3/,0/0", Default4( 1.00, 1.00, 1.00, 1.00 ) );
	CreateInputTexture2D( BlueNormal, Linear, 8, "NormalizeNormals", "_normal", "Blue Channel,4/,0/0", Default4( 1.00, 1.00, 1.00, 1.00 ) );
	CreateInputTexture2D( GlobalORM, Linear, 8, "None", "_rough", "Base Textures,1/,0/0", Default4( 1.00, 1.00, 1.00, 1.00 ) );
	CreateInputTexture2D( RedORM, Linear, 8, "None", "_mask", "Red Channel,2/,0/0", Default4( 1.00, 1.00, 1.00, 1.00 ) );
	CreateInputTexture2D( GreenORM, Linear, 8, "None", "_mask", "Green Channel,3/,0/0", Default4( 1.00, 1.00, 1.00, 1.00 ) );
	CreateInputTexture2D( BlueORM, Linear, 8, "None", "_mask", "Blue Channel,4/,0/0", Default4( 1.00, 1.00, 1.00, 1.00 ) );
	Texture2D g_tGlobalAlbedo < Channel( RGBA, Box( GlobalAlbedo ), Srgb ); OutputFormat( DXT5 ); SrgbRead( True ); >;
	Texture2D g_tRedAlbedo < Channel( RGBA, Box( RedAlbedo ), Srgb ); OutputFormat( DXT5 ); SrgbRead( True ); >;
	Texture2D g_tRGBVariationMask < Channel( RGBA, Box( RGBVariationMask ), Linear ); OutputFormat( DXT5 ); SrgbRead( False ); >;
	Texture2D g_tGreenAlbedo < Channel( RGBA, Box( GreenAlbedo ), Srgb ); OutputFormat( DXT5 ); SrgbRead( True ); >;
	Texture2D g_tBlueAlbedo < Channel( RGBA, Box( BlueAlbedo ), Srgb ); OutputFormat( DXT5 ); SrgbRead( True ); >;
	Texture2D g_tGlobalNormal < Channel( RGBA, Box( GlobalNormal ), Linear ); OutputFormat( DXT5 ); SrgbRead( False ); >;
	Texture2D g_tRedNormal < Channel( RGBA, Box( RedNormal ), Linear ); OutputFormat( DXT5 ); SrgbRead( False ); >;
	Texture2D g_tGreenNormal < Channel( RGBA, Box( GreenNormal ), Linear ); OutputFormat( DXT5 ); SrgbRead( False ); >;
	Texture2D g_tBlueNormal < Channel( RGBA, Box( BlueNormal ), Linear ); OutputFormat( DXT5 ); SrgbRead( False ); >;
	Texture2D g_tGlobalORM < Channel( RGBA, Box( GlobalORM ), Linear ); OutputFormat( DXT5 ); SrgbRead( False ); >;
	Texture2D g_tRedORM < Channel( RGBA, Box( RedORM ), Linear ); OutputFormat( DXT5 ); SrgbRead( False ); >;
	Texture2D g_tGreenORM < Channel( RGBA, Box( GreenORM ), Linear ); OutputFormat( DXT5 ); SrgbRead( False ); >;
	Texture2D g_tBlueORM < Channel( RGBA, Box( BlueORM ), Linear ); OutputFormat( DXT5 ); SrgbRead( False ); >;
	float2 g_vBaseTiling < UiGroup( "Base Textures,1/,0/0" ); Default2( 1,1 ); >;
	float2 g_vRedTiling < UiGroup( "Red Channel,2/,0/0" ); Default2( 1,1 ); >;
	float4 g_vRedTint < UiType( Color ); UiGroup( "Red Channel,2/,0/0" ); Default4( 1.00, 1.00, 1.00, 1.00 ); >;
	float g_flRedMaskStrength < UiGroup( "Red Channel,2/,0/0" ); Default1( 1 ); Range1( 0, 10 ); >;
	bool g_bRedUseAlbedo < UiGroup( "Red Channel,2/,0/0" ); Default( 1 ); >;
	float2 g_vGreenTiling < UiGroup( "Green Channel,3/,0/0" ); Default2( 1,1 ); >;
	float4 g_vGreenTint < UiType( Color ); UiGroup( "Green Channel,3/,0/0" ); Default4( 1.00, 1.00, 1.00, 1.00 ); >;
	float g_flGreenMaskStrength < UiGroup( "Green Channel,3/,0/0" ); Default1( 1 ); Range1( 0, 10 ); >;
	bool g_bGreenUseAlbedo < UiGroup( "Green Channel,3/,0/0" ); Default( 1 ); >;
	float2 g_vBlueTiling < UiGroup( "Blue Channel,4/,0/0" ); Default2( 1,1 ); >;
	float4 g_vBlueTint < UiType( Color ); UiGroup( "Blue Channel,4/,0/0" ); Default4( 1.00, 1.00, 1.00, 1.00 ); >;
	float g_flBlueMaskStrength < UiGroup( "Blue Channel,4/,0/0" ); Default1( 3.076231 ); Range1( 0, 10 ); >;
	bool g_bBlueUseAlbedo < UiGroup( "Blue Channel,4/,0/0" ); Default( 1 ); >;
	bool g_bRedUseNormal < UiGroup( "Red Channel,2/,0/0" ); Default( 0 ); >;
	bool g_bGreenUseNormal < UiGroup( "Green Channel,3/,0/0" ); Default( 0 ); >;
	bool g_bBlueUseNormal < UiGroup( "Blue Channel,4/,0/0" ); Default( 0 ); >;
	bool g_bRedUseRoughness < UiGroup( "Red Channel,2/,0/0" ); Default( 0 ); >;
	bool g_bGreenUseRoughness < UiGroup( "Green Channel,3/,0/0" ); Default( 0 ); >;
	bool g_bBlueUseRoughness < UiGroup( "Blue Channel,4/,0/0" ); Default( 0 ); >;
	bool g_bRedUseMetallic < UiGroup( "Red Channel,2/,0/0" ); Default( 0 ); >;
	bool g_bGreenUseMetallic < UiGroup( "Green Channel,3/,0/0" ); Default( 0 ); >;
	bool g_bBlueUseMetallic < UiGroup( "Blue Channel,4/,0/0" ); Default( 0 ); >;
	bool g_bRedUseAO < UiGroup( "Red Channel,2/,0/0" ); Default( 0 ); >;
	bool g_bGreenUseAO < UiGroup( "Green Channel,3/,0/0" ); Default( 0 ); >;
	bool g_bBlueUseAO < UiGroup( "Blue Channel,4/,0/0" ); Default( 0 ); >;
	
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
		
		float2 local0 = i.vTextureCoords.xy * float2( 1, 1 );
		float2 local1 = g_vBaseTiling;
		float2 local2 = local0 * local1;
		float4 local3 = Tex2DS( g_tGlobalAlbedo, g_sSampler0, local2 );
		float2 local4 = i.vTextureCoords.xy * float2( 1, 1 );
		float2 local5 = g_vRedTiling;
		float2 local6 = local4 * local5;
		float4 local7 = Tex2DS( g_tRedAlbedo, g_sSampler0, local6 );
		float4 local8 = g_vRedTint;
		float4 local9 = local7 * local8;
		float4 local10 = Tex2DS( g_tRGBVariationMask, g_sSampler0, i.vTextureCoords.xy );
		float local11 = g_flRedMaskStrength;
		float local12 = local10.r * local11;
		float local13 = saturate( local12 );
		float local14 = g_bRedUseAlbedo ? local13 : 0;
		float4 local15 = lerp( local3, local9, local14 );
		float2 local16 = i.vTextureCoords.xy * float2( 1, 1 );
		float2 local17 = g_vGreenTiling;
		float2 local18 = local16 * local17;
		float4 local19 = Tex2DS( g_tGreenAlbedo, g_sSampler0, local18 );
		float4 local20 = g_vGreenTint;
		float4 local21 = local19 * local20;
		float local22 = g_flGreenMaskStrength;
		float local23 = local10.g * local22;
		float local24 = saturate( local23 );
		float local25 = g_bGreenUseAlbedo ? local24 : 0;
		float4 local26 = lerp( local15, local21, local25 );
		float2 local27 = i.vTextureCoords.xy * float2( 1, 1 );
		float2 local28 = g_vBlueTiling;
		float2 local29 = local27 * local28;
		float4 local30 = Tex2DS( g_tBlueAlbedo, g_sSampler0, local29 );
		float4 local31 = g_vBlueTint;
		float4 local32 = local30 * local31;
		float local33 = g_flBlueMaskStrength;
		float local34 = local10.b * local33;
		float local35 = saturate( local34 );
		float local36 = g_bBlueUseAlbedo ? local35 : 0;
		float4 local37 = lerp( local26, local32, local36 );
		float4 local38 = Tex2DS( g_tGlobalNormal, g_sSampler0, local2 );
		float4 local39 = Tex2DS( g_tRedNormal, g_sSampler0, local6 );
		float local40 = saturate( local12 );
		float local41 = g_bRedUseNormal ? local40 : 0;
		float4 local42 = saturate( lerp( local38, Overlay_blend( local38, local39 ), local41 ) );
		float4 local43 = Tex2DS( g_tGreenNormal, g_sSampler0, local18 );
		float local44 = saturate( local23 );
		float local45 = g_bGreenUseNormal ? local44 : 0;
		float4 local46 = saturate( lerp( local42, Overlay_blend( local42, local43 ), local45 ) );
		float4 local47 = Tex2DS( g_tBlueNormal, g_sSampler0, local29 );
		float local48 = saturate( local34 );
		float local49 = g_bBlueUseNormal ? local48 : 0;
		float4 local50 = saturate( lerp( local46, Overlay_blend( local46, local47 ), local49 ) );
		float3 local51 = TransformNormal( i, DecodeNormal( local50.xyz ) );
		float4 local52 = Tex2DS( g_tGlobalORM, g_sSampler0, local2 );
		float4 local53 = Tex2DS( g_tRedORM, g_sSampler0, local6 );
		float local54 = saturate( local12 );
		float local55 = g_bRedUseRoughness ? local54 : 0;
		float local56 = lerp( local52.g, local53.g, local55 );
		float4 local57 = Tex2DS( g_tGreenORM, g_sSampler0, local18 );
		float local58 = saturate( local23 );
		float local59 = g_bGreenUseRoughness ? local58 : 0;
		float local60 = lerp( local56, local57.g, local59 );
		float4 local61 = Tex2DS( g_tBlueORM, g_sSampler0, local29 );
		float local62 = saturate( local34 );
		float local63 = g_bBlueUseRoughness ? local62 : 0;
		float local64 = lerp( local60, local61.g, local63 );
		float local65 = saturate( local12 );
		float local66 = g_bRedUseMetallic ? local65 : 0;
		float local67 = lerp( local52.b, local53.b, local66 );
		float local68 = saturate( local23 );
		float local69 = g_bGreenUseMetallic ? local68 : 0;
		float local70 = lerp( local67, local57.b, local69 );
		float local71 = saturate( local34 );
		float local72 = g_bBlueUseMetallic ? local71 : 0;
		float local73 = lerp( local70, local61.b, local72 );
		float local74 = saturate( local12 );
		float local75 = g_bRedUseAO ? local74 : 0;
		float local76 = lerp( local52.r, local53.r, local75 );
		float local77 = saturate( local23 );
		float local78 = g_bGreenUseAO ? local77 : 0;
		float local79 = lerp( local76, local57.r, local78 );
		float local80 = saturate( local34 );
		float local81 = g_bBlueUseAO ? local80 : 0;
		float local82 = lerp( local79, local61.r, local81 );
		
		m.Albedo = local37.xyz;
		m.Opacity = 1;
		m.Normal = local51;
		m.Roughness = local64;
		m.Metalness = local73;
		m.AmbientOcclusion = local82;
		
		m.AmbientOcclusion = saturate( m.AmbientOcclusion );
		m.Roughness = saturate( m.Roughness );
		m.Metalness = saturate( m.Metalness );
		m.Opacity = saturate( m.Opacity );
		
		return ShadingModelStandard::Shade( i, m );
	}
}
