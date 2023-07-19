
HEADER
{
	Description = "";
}

FEATURES
{
	#include "common/features.hlsl"
}

MODES
{
	VrForward();
	Depth(); 
	ToolsVis( S_MODE_TOOLS_VIS );
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
	#include "procedural.hlsl"

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

	PixelInput MainVs( VertexInput v )
	{
		PixelInput i = ProcessVertex( v );
		i.vPositionOs = v.vPositionOs.xyz;

		return FinalizeVertex( i );
	}
}

PS
{
	#include "common/pixel.hlsl"
	
	SamplerState g_sSampler0 < Filter( ANISO ); AddressU( WRAP ); AddressV( WRAP ); >;
	CreateInputTexture2D( GlobalAlbedo, Srgb, 8, "None", "_color", "Base Textures,1/,0/0", Default4( 1.00, 1.00, 1.00, 1.00 ) );
	CreateInputTexture2D( RedAlbedo, Srgb, 8, "None", "_color", "Red Channel,2/,0/1", Default4( 1.00, 1.00, 1.00, 1.00 ) );
	CreateInputTexture2D( RGBVariationMask, Linear, 8, "None", "_mask", "Unique Textures,0/,0/0", Default4( 1.00, 1.00, 1.00, 1.00 ) );
	CreateInputTexture2D( GreenAlbedo, Srgb, 8, "None", "_color", "Green Channel,3/,0/1", Default4( 1.00, 1.00, 1.00, 1.00 ) );
	CreateInputTexture2D( BlueAlbedo, Srgb, 8, "None", "_color", "Blue Channel,4/,0/1", Default4( 1.00, 1.00, 1.00, 1.00 ) );
	CreateInputTexture2D( GlobalNormal, Linear, 8, "NormalizeNormals", "_normal", "Base Textures,1/,0/2", Default4( 1.00, 1.00, 1.00, 1.00 ) );
	CreateInputTexture2D( BakedNormal, Linear, 8, "NormalizeNormals", "_normal", "Unique Textures,0/,0/1", Default4( 1.00, 1.00, 1.00, 1.00 ) );
	CreateInputTexture2D( RedNormal, Linear, 8, "NormalizeNormals", "_normal", "Red Channel,2/,0/4", Default4( 1.00, 1.00, 1.00, 1.00 ) );
	CreateInputTexture2D( GreenNormal, Linear, 8, "NormalizeNormals", "_normal", "Green Channel,3/,0/4", Default4( 1.00, 1.00, 1.00, 1.00 ) );
	CreateInputTexture2D( BlueNormal, Linear, 8, "NormalizeNormals", "_normal", "Blue Channel,4/,0/4", Default4( 1.00, 1.00, 1.00, 1.00 ) );
	CreateInputTexture2D( GlobalORM, Linear, 8, "None", "_color", "Base Textures,1/,0/1", Default4( 1.00, 1.00, 1.00, 1.00 ) );
	CreateInputTexture2D( RedORM, Linear, 8, "None", "_color", "Red Channel,2/,0/3", Default4( 1.00, 1.00, 1.00, 1.00 ) );
	CreateInputTexture2D( GreenORM, Linear, 8, "None", "_color", "Green Channel,3/,0/3", Default4( 1.00, 1.00, 1.00, 1.00 ) );
	CreateInputTexture2D( BlueORM, Linear, 8, "None", "_color", "Blue Channel,4/,0/3", Default4( 1.00, 1.00, 1.00, 1.00 ) );
	Texture2D g_tGlobalAlbedo < Channel( RGBA, Box( GlobalAlbedo ), Srgb ); OutputFormat( DXT5 ); SrgbRead( True ); >;
	Texture2D g_tRedAlbedo < Channel( RGBA, Box( RedAlbedo ), Srgb ); OutputFormat( DXT5 ); SrgbRead( True ); >;
	Texture2D g_tRGBVariationMask < Channel( RGBA, Box( RGBVariationMask ), Linear ); OutputFormat( DXT5 ); SrgbRead( False ); >;
	Texture2D g_tGreenAlbedo < Channel( RGBA, Box( GreenAlbedo ), Srgb ); OutputFormat( DXT5 ); SrgbRead( True ); >;
	Texture2D g_tBlueAlbedo < Channel( RGBA, Box( BlueAlbedo ), Srgb ); OutputFormat( DXT5 ); SrgbRead( True ); >;
	Texture2D g_tGlobalNormal < Channel( RGBA, Box( GlobalNormal ), Linear ); OutputFormat( DXT5 ); SrgbRead( False ); >;
	Texture2D g_tBakedNormal < Channel( RGBA, Box( BakedNormal ), Linear ); OutputFormat( DXT5 ); SrgbRead( False ); >;
	Texture2D g_tRedNormal < Channel( RGBA, Box( RedNormal ), Linear ); OutputFormat( DXT5 ); SrgbRead( False ); >;
	Texture2D g_tGreenNormal < Channel( RGBA, Box( GreenNormal ), Linear ); OutputFormat( DXT5 ); SrgbRead( False ); >;
	Texture2D g_tBlueNormal < Channel( RGBA, Box( BlueNormal ), Linear ); OutputFormat( DXT5 ); SrgbRead( False ); >;
	Texture2D g_tGlobalORM < Channel( RGBA, Box( GlobalORM ), Linear ); OutputFormat( DXT5 ); SrgbRead( False ); >;
	Texture2D g_tRedORM < Channel( RGBA, Box( RedORM ), Linear ); OutputFormat( DXT5 ); SrgbRead( False ); >;
	Texture2D g_tGreenORM < Channel( RGBA, Box( GreenORM ), Linear ); OutputFormat( DXT5 ); SrgbRead( False ); >;
	Texture2D g_tBlueORM < Channel( RGBA, Box( BlueORM ), Linear ); OutputFormat( DXT5 ); SrgbRead( False ); >;
	bool g_bBaseUseSecondaryCoord < UiGroup( "Base Textures,1/,0/4" ); Default( 0 ); >;
	float2 g_vBaseTiling < UiGroup( "Base Textures,1/,0/3" ); Default2( 1,1 ); >;
	bool g_bRedUseSecondaryCoord < UiGroup( "Red Channel,2/,0/6" ); Default( 0 ); >;
	float2 g_vRedTiling < UiGroup( "Red Channel,2/,0/5" ); Default2( 1,1 ); >;
	float4 g_vRedTint < UiType( Color ); UiGroup( "Red Channel,2/,0/2" ); Default4( 1.00, 1.00, 1.00, 1.00 ); >;
	bool g_bUniqueUseSecondaryCoord < UiGroup( "Unique Textures,0/,0/4" ); Default( 0 ); >;
	float g_flRedMaskStrength < UiGroup( "Red Channel,2/,0/0" ); Default1( 1 ); Range1( 0, 10 ); >;
	bool g_bRedUseAlbedo < UiGroup( "Red Channel,2/,0/7" ); Default( 1 ); >;
	bool g_bGreenUseSecondaryCoord < UiGroup( "Green Channel,3/,0/6" ); Default( 0 ); >;
	float2 g_vGreenTiling < UiGroup( "Green Channel,3/,0/5" ); Default2( 1,1 ); >;
	float4 g_vGreenTint < UiType( Color ); UiGroup( "Green Channel,3/,0/2" ); Default4( 1.00, 1.00, 1.00, 1.00 ); >;
	float g_flGreenMaskStrength < UiGroup( "Green Channel,3/,0/0" ); Default1( 1 ); Range1( 0, 10 ); >;
	bool g_bGreenUseAlbedo < UiGroup( "Green Channel,3/,0/7" ); Default( 1 ); >;
	bool g_bBlueUseSecondaryCoord < UiGroup( "Blue Channel,4/,0/6" ); Default( 0 ); >;
	float2 g_vBlueTiling < UiGroup( "Blue Channel,4/,0/5" ); Default2( 1,1 ); >;
	float4 g_vBlueTint < UiType( Color ); UiGroup( "Blue Channel,4/,0/2" ); Default4( 1.00, 1.00, 1.00, 1.00 ); >;
	float g_flBlueMaskStrength < UiGroup( "Blue Channel,4/,0/0" ); Default1( 3.076231 ); Range1( 0, 10 ); >;
	bool g_bBlueUseAlbedo < UiGroup( "Blue Channel,4/,0/7" ); Default( 1 ); >;
	float g_flBakedNormalBlend < UiGroup( "Unique Textures,0/,0/2" ); Default1( 0.5 ); Range1( 0, 1 ); >;
	bool g_bRedUseNormal < UiGroup( "Red Channel,2/,0/11" ); Default( 0 ); >;
	bool g_bGreenUseNormal < UiGroup( "Green Channel,3/,0/11" ); Default( 0 ); >;
	bool g_bBlueUseNormal < UiGroup( "Blue Channel,4/,0/11" ); Default( 0 ); >;
	bool g_bRedUseRoughness < UiGroup( "Red Channel,2/,0/9" ); Default( 0 ); >;
	bool g_bGreenUseRoughness < UiGroup( "Green Channel,3/,0/9" ); Default( 0 ); >;
	bool g_bBlueUseRoughness < UiGroup( "Blue Channel,4/,0/9" ); Default( 0 ); >;
	bool g_bRedUseMetallic < UiGroup( "Red Channel,2/,0/10" ); Default( 0 ); >;
	bool g_bGreenUseMetallic < UiGroup( "Green Channel,3/,0/10" ); Default( 0 ); >;
	bool g_bBlueUseMetallic < UiGroup( "Blue Channel,4/,0/10" ); Default( 0 ); >;
	bool g_bRedUseAO < UiGroup( "Red Channel,2/,0/8" ); Default( 0 ); >;
	bool g_bGreenUseAO < UiGroup( "Green Channel,3/,0/8" ); Default( 0 ); >;
	bool g_bBlueUseAO < UiGroup( "Blue Channel,4/,0/8" ); Default( 0 ); >;
		
	float Overlay_blend( float a, float b )
	{
	    if ( a <= 0.5f )
	        return 2.0f * a * b;
	    else
	        return 1.0f - 2.0f * ( 1.0f - a ) * ( 1.0f - b );
	}
	
	float3 Overlay_blend( float3 a, float3 b )
	{
	    return float3(
	        Overlay_blend( a.r, b.r ),
	        Overlay_blend( a.g, b.g ),
	        Overlay_blend( a.b, b.b )
		);
	}
	
	float4 Overlay_blend( float4 a, float4 b, bool blendAlpha = false )
	{
	    return float4(
	        Overlay_blend( a.rgb, b.rgb ).rgb,
	        blendAlpha ? Overlay_blend( a.a, b.a ) : max( a.a, b.a )
	    );
	}
	
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
		
		float2 l_0 = i.vTextureCoords.zw * float2( 1, 1 );
		float2 l_1 = i.vTextureCoords.xy * float2( 1, 1 );
		float2 l_2 = g_bBaseUseSecondaryCoord ? l_0 : l_1;
		float2 l_3 = g_vBaseTiling;
		float2 l_4 = l_2 * l_3;
		float4 l_5 = Tex2DS( g_tGlobalAlbedo, g_sSampler0, l_4 );
		float2 l_6 = i.vTextureCoords.zw * float2( 1, 1 );
		float2 l_7 = i.vTextureCoords.xy * float2( 1, 1 );
		float2 l_8 = g_bRedUseSecondaryCoord ? l_6 : l_7;
		float2 l_9 = g_vRedTiling;
		float2 l_10 = l_8 * l_9;
		float4 l_11 = Tex2DS( g_tRedAlbedo, g_sSampler0, l_10 );
		float4 l_12 = g_vRedTint;
		float4 l_13 = l_11 * l_12;
		float2 l_14 = i.vTextureCoords.zw * float2( 1, 1 );
		float2 l_15 = i.vTextureCoords.xy * float2( 1, 1 );
		float2 l_16 = g_bUniqueUseSecondaryCoord ? l_14 : l_15;
		float4 l_17 = Tex2DS( g_tRGBVariationMask, g_sSampler0, l_16 );
		float l_18 = g_flRedMaskStrength;
		float l_19 = l_17.r * l_18;
		float l_20 = saturate( l_19 );
		float l_21 = g_bRedUseAlbedo ? l_20 : 0;
		float4 l_22 = lerp( l_5, l_13, l_21 );
		float2 l_23 = i.vTextureCoords.zw * float2( 1, 1 );
		float2 l_24 = i.vTextureCoords.xy * float2( 1, 1 );
		float2 l_25 = g_bGreenUseSecondaryCoord ? l_23 : l_24;
		float2 l_26 = g_vGreenTiling;
		float2 l_27 = l_25 * l_26;
		float4 l_28 = Tex2DS( g_tGreenAlbedo, g_sSampler0, l_27 );
		float4 l_29 = g_vGreenTint;
		float4 l_30 = l_28 * l_29;
		float l_31 = g_flGreenMaskStrength;
		float l_32 = l_17.g * l_31;
		float l_33 = saturate( l_32 );
		float l_34 = g_bGreenUseAlbedo ? l_33 : 0;
		float4 l_35 = lerp( l_22, l_30, l_34 );
		float2 l_36 = i.vTextureCoords.zw * float2( 1, 1 );
		float2 l_37 = i.vTextureCoords.xy * float2( 1, 1 );
		float2 l_38 = g_bBlueUseSecondaryCoord ? l_36 : l_37;
		float2 l_39 = g_vBlueTiling;
		float2 l_40 = l_38 * l_39;
		float4 l_41 = Tex2DS( g_tBlueAlbedo, g_sSampler0, l_40 );
		float4 l_42 = g_vBlueTint;
		float4 l_43 = l_41 * l_42;
		float l_44 = g_flBlueMaskStrength;
		float l_45 = l_17.b * l_44;
		float l_46 = saturate( l_45 );
		float l_47 = g_bBlueUseAlbedo ? l_46 : 0;
		float4 l_48 = lerp( l_35, l_43, l_47 );
		float4 l_49 = Tex2DS( g_tGlobalNormal, g_sSampler0, l_4 );
		float4 l_50 = Tex2DS( g_tBakedNormal, g_sSampler0, l_16 );
		float l_51 = g_flBakedNormalBlend;
		float4 l_52 = saturate( lerp( l_49, Overlay_blend( l_49, l_50 ), l_51 ) );
		float4 l_53 = Tex2DS( g_tRedNormal, g_sSampler0, l_10 );
		float l_54 = saturate( l_19 );
		float l_55 = g_bRedUseNormal ? l_54 : 0;
		float4 l_56 = saturate( lerp( l_52, Overlay_blend( l_52, l_53 ), l_55 ) );
		float4 l_57 = Tex2DS( g_tGreenNormal, g_sSampler0, l_27 );
		float l_58 = saturate( l_32 );
		float l_59 = g_bGreenUseNormal ? l_58 : 0;
		float4 l_60 = saturate( lerp( l_56, Overlay_blend( l_56, l_57 ), l_59 ) );
		float4 l_61 = Tex2DS( g_tBlueNormal, g_sSampler0, l_40 );
		float l_62 = saturate( l_45 );
		float l_63 = g_bBlueUseNormal ? l_62 : 0;
		float4 l_64 = saturate( lerp( l_60, Overlay_blend( l_60, l_61 ), l_63 ) );
		float3 l_65 = TransformNormal( i, DecodeNormal( l_64.xyz ) );
		float4 l_66 = Tex2DS( g_tGlobalORM, g_sSampler0, l_4 );
		float4 l_67 = Tex2DS( g_tRedORM, g_sSampler0, l_10 );
		float l_68 = saturate( l_19 );
		float l_69 = g_bRedUseRoughness ? l_68 : 0;
		float l_70 = lerp( l_66.g, l_67.g, l_69 );
		float4 l_71 = Tex2DS( g_tGreenORM, g_sSampler0, l_27 );
		float l_72 = saturate( l_32 );
		float l_73 = g_bGreenUseRoughness ? l_72 : 0;
		float l_74 = lerp( l_70, l_71.g, l_73 );
		float4 l_75 = Tex2DS( g_tBlueORM, g_sSampler0, l_40 );
		float l_76 = saturate( l_45 );
		float l_77 = g_bBlueUseRoughness ? l_76 : 0;
		float l_78 = lerp( l_74, l_75.g, l_77 );
		float l_79 = saturate( l_19 );
		float l_80 = g_bRedUseMetallic ? l_79 : 0;
		float l_81 = lerp( l_66.b, l_67.b, l_80 );
		float l_82 = saturate( l_32 );
		float l_83 = g_bGreenUseMetallic ? l_82 : 0;
		float l_84 = lerp( l_81, l_71.b, l_83 );
		float l_85 = saturate( l_45 );
		float l_86 = g_bBlueUseMetallic ? l_85 : 0;
		float l_87 = lerp( l_84, l_75.b, l_86 );
		float l_88 = saturate( l_19 );
		float l_89 = g_bRedUseAO ? l_88 : 0;
		float l_90 = lerp( l_66.r, l_67.r, l_89 );
		float l_91 = saturate( l_32 );
		float l_92 = g_bGreenUseAO ? l_91 : 0;
		float l_93 = lerp( l_90, l_71.r, l_92 );
		float l_94 = saturate( l_45 );
		float l_95 = g_bBlueUseAO ? l_94 : 0;
		float l_96 = lerp( l_93, l_75.r, l_95 );
		
		m.Albedo = l_48.xyz;
		m.Opacity = 1;
		m.Normal = l_65;
		m.Roughness = l_78;
		m.Metalness = l_87;
		m.AmbientOcclusion = l_96;
		
		m.AmbientOcclusion = saturate( m.AmbientOcclusion );
		m.Roughness = saturate( m.Roughness );
		m.Metalness = saturate( m.Metalness );
		m.Opacity = saturate( m.Opacity );
		
		return ShadingModelStandard::Shade( i, m );
	}
}
