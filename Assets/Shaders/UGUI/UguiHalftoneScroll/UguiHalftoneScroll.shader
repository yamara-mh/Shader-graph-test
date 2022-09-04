Shader "UguiHalftoneScroll"
{
    Properties
    {
        [NoScaleOffset]_MainTex("MainTex", 2D) = "white" {}
        _Fineness("Fineness", Float) = 5
        _Speed("Speed", Vector) = (0.5, -1, 0, 0)
        _InColor("InColor", Color) = (1, 1, 1, 1)
        _OutColor("OutColor", Color) = (0, 0, 0, 0)
        _CutOut("CutOut", Range(0, 1)) = 0.5
        _FadeAngle("FadeAngle", Range(-180, 180)) = -90
        _FadeStart("FadeStart", Float) = 0
        _FadeEnd("FadeEnd", Float) = 1
        [HideInInspector][NoScaleOffset]unity_Lightmaps("unity_Lightmaps", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_LightmapsInd("unity_LightmapsInd", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_ShadowMasks("unity_ShadowMasks", 2DArray) = "" {}

        _StencilComp ("Stencil Comparison", Float) = 8
        _Stencil ("Stencil ID", Float) = 0
        _StencilOp ("Stencil Operation", Float) = 0
        _StencilWriteMask ("Stencil Write Mask", Float) = 255
        _StencilReadMask ("Stencil Read Mask", Float) = 255
        _ColorMask ("Color Mask", Float) = 15
    }
    SubShader
    {
        Tags
        {
            "RenderPipeline"="UniversalPipeline"
            "RenderType"="Transparent"
            "UniversalMaterialType" = "Unlit"
            "Queue"="Transparent"
            "ShaderGraphShader"="true"
            "ShaderGraphTargetId"=""
        }
        Stencil
        {
         Ref [_Stencil]
         Comp [_StencilComp]
         Pass [_StencilOp]
         ReadMask [_StencilReadMask]
         WriteMask [_StencilWriteMask]
        }
        Pass
        {
            Name "Sprite Unlit"
            Tags
            {
                "LightMode" = "Universal2D"
            }
        
            // Render State
            Cull Off
        Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
        ZTest [unity_GUIZTestMode]
        ZWrite Off

        ColorMask [_ColorMask]
        
            // Debug
            // <None>
        
            // --------------------------------------------------
            // Pass
        
            HLSLPROGRAM
        
            // Pragmas
            #pragma target 2.0
        #pragma exclude_renderers d3d11_9x
        #pragma vertex vert
        #pragma fragment frag
        
            // DotsInstancingOptions: <None>
            // HybridV1InjectedBuiltinProperties: <None>
        
            // Keywords
            #pragma multi_compile_fragment _ DEBUG_DISPLAY
            // GraphKeywords: <None>
        
            // Defines
            #define _SURFACE_TYPE_TRANSPARENT 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define ATTRIBUTES_NEED_COLOR
            #define VARYINGS_NEED_POSITION_WS
            #define VARYINGS_NEED_TEXCOORD0
            #define VARYINGS_NEED_COLOR
            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_SPRITEUNLIT
            /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
            // Includes
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreInclude' */
        
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
            // --------------------------------------------------
            // Structs and Packing
        
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
            struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 color : COLOR;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float4 texCoord0;
             float4 color;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 ObjectSpacePosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
             float4 interp1 : INTERP1;
             float4 interp2 : INTERP2;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
            PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyzw =  input.texCoord0;
            output.interp2.xyzw =  input.color;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            output.texCoord0 = input.interp1.xyzw;
            output.color = input.interp2.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
            // --------------------------------------------------
            // Graph
        
            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
        float2 _Speed;
        float _FadeAngle;
        float4 _OutColor;
        float4 _MainTex_TexelSize;
        float _CutOut;
        float4 _InColor;
        float _Fineness;
        float _FadeStart;
        float _FadeEnd;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_MainTex);
        SAMPLER(sampler_MainTex);
        
            // Graph Includes
            // GraphIncludes: <None>
        
            // -- Property used by ScenePickingPass
            #ifdef SCENEPICKINGPASS
            float4 _SelectionID;
            #endif
        
            // -- Properties used by SceneSelectionPass
            #ifdef SCENESELECTIONPASS
            int _ObjectId;
            int _PassValue;
            #endif
        
            // Graph Functions
            
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_Fraction_float2(float2 In, out float2 Out)
        {
            Out = frac(In);
        }
        
        void Unity_Step_float(float Edge, float In, out float Out)
        {
            Out = step(Edge, In);
        }
        
        void Unity_Rotate_Degrees_float(float2 UV, float2 Center, float Rotation, out float2 Out)
        {
            //rotation matrix
            Rotation = Rotation * (3.1415926f/180.0f);
            UV -= Center;
            float s = sin(Rotation);
            float c = cos(Rotation);
        
            //center rotation matrix
            float2x2 rMatrix = float2x2(c, -s, s, c);
            rMatrix *= 0.5;
            rMatrix += 0.5;
            rMatrix = rMatrix*2 - 1;
        
            //multiply the UVs by the rotation matrix
            UV.xy = mul(UV.xy, rMatrix);
            UV += Center;
        
            Out = UV;
        }
        
        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
            // Graph Vertex
            struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
            #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
            // Graph Pixel
            struct SurfaceDescription
        {
            float3 BaseColor;
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_c1246444df68471ca9c2cf4c05d44a7f_Out_0 = UnityBuildTexture2DStructNoScale(_MainTex);
            float _Property_c45f657fa12d465288bfb9a8abe7e0c7_Out_0 = _Fineness;
            float3 _Multiply_3c38c1bff1b24fdabe33a7c9a5368f47_Out_2;
            Unity_Multiply_float3_float3(IN.ObjectSpacePosition, (_Property_c45f657fa12d465288bfb9a8abe7e0c7_Out_0.xxx), _Multiply_3c38c1bff1b24fdabe33a7c9a5368f47_Out_2);
            float2 _Property_6bf3322506034db480e189df64741c4b_Out_0 = _Speed;
            float2 _Multiply_d5bc2af014fb4e1984423be16e940dae_Out_2;
            Unity_Multiply_float2_float2((IN.TimeParameters.x.xx), _Property_6bf3322506034db480e189df64741c4b_Out_0, _Multiply_d5bc2af014fb4e1984423be16e940dae_Out_2);
            float2 _TilingAndOffset_31ff98aece294bfb8c46c8833c23721c_Out_3;
            Unity_TilingAndOffset_float((_Multiply_3c38c1bff1b24fdabe33a7c9a5368f47_Out_2.xy), float2 (0.01, 0.01), _Multiply_d5bc2af014fb4e1984423be16e940dae_Out_2, _TilingAndOffset_31ff98aece294bfb8c46c8833c23721c_Out_3);
            float2 _Fraction_ddd49d606aa64e98818684e1f5ca2a4b_Out_1;
            Unity_Fraction_float2(_TilingAndOffset_31ff98aece294bfb8c46c8833c23721c_Out_3, _Fraction_ddd49d606aa64e98818684e1f5ca2a4b_Out_1);
            float4 _SampleTexture2D_59795b66471740a39814ec94d2056178_RGBA_0 = SAMPLE_TEXTURE2D(_Property_c1246444df68471ca9c2cf4c05d44a7f_Out_0.tex, _Property_c1246444df68471ca9c2cf4c05d44a7f_Out_0.samplerstate, _Property_c1246444df68471ca9c2cf4c05d44a7f_Out_0.GetTransformedUV(_Fraction_ddd49d606aa64e98818684e1f5ca2a4b_Out_1));
            float _SampleTexture2D_59795b66471740a39814ec94d2056178_R_4 = _SampleTexture2D_59795b66471740a39814ec94d2056178_RGBA_0.r;
            float _SampleTexture2D_59795b66471740a39814ec94d2056178_G_5 = _SampleTexture2D_59795b66471740a39814ec94d2056178_RGBA_0.g;
            float _SampleTexture2D_59795b66471740a39814ec94d2056178_B_6 = _SampleTexture2D_59795b66471740a39814ec94d2056178_RGBA_0.b;
            float _SampleTexture2D_59795b66471740a39814ec94d2056178_A_7 = _SampleTexture2D_59795b66471740a39814ec94d2056178_RGBA_0.a;
            float _Property_245e5fad73664cf48bdabc8e401deac4_Out_0 = _CutOut;
            float _Step_4cec721205f847bc83ed9703c7e55f4f_Out_2;
            Unity_Step_float(_Property_245e5fad73664cf48bdabc8e401deac4_Out_0, _SampleTexture2D_59795b66471740a39814ec94d2056178_R_4, _Step_4cec721205f847bc83ed9703c7e55f4f_Out_2);
            float _Property_8fab37fa17404320acbb12bcdf8ab86c_Out_0 = _FadeStart;
            float _Property_8342fbde3d9c4d869e9a3c0b47bcb505_Out_0 = _FadeEnd;
            float _Property_9b787bff13fb4bfb8c1990460838cc47_Out_0 = _FadeAngle;
            float2 _Rotate_0fc591d64b9e4fe6bd24accc72eedb35_Out_3;
            Unity_Rotate_Degrees_float(IN.uv0.xy, float2 (0.5, 0.5), _Property_9b787bff13fb4bfb8c1990460838cc47_Out_0, _Rotate_0fc591d64b9e4fe6bd24accc72eedb35_Out_3);
            float _Split_2fb787a8ca3b491da2cceb170763c878_R_1 = _Rotate_0fc591d64b9e4fe6bd24accc72eedb35_Out_3[0];
            float _Split_2fb787a8ca3b491da2cceb170763c878_G_2 = _Rotate_0fc591d64b9e4fe6bd24accc72eedb35_Out_3[1];
            float _Split_2fb787a8ca3b491da2cceb170763c878_B_3 = 0;
            float _Split_2fb787a8ca3b491da2cceb170763c878_A_4 = 0;
            float _Smoothstep_a9b7ff11a107421bb0c85a2f432da89b_Out_3;
            Unity_Smoothstep_float(_Property_8fab37fa17404320acbb12bcdf8ab86c_Out_0, _Property_8342fbde3d9c4d869e9a3c0b47bcb505_Out_0, _Split_2fb787a8ca3b491da2cceb170763c878_R_1, _Smoothstep_a9b7ff11a107421bb0c85a2f432da89b_Out_3);
            float _Multiply_11161919d70a4677afa5464991e82604_Out_2;
            Unity_Multiply_float_float(_Step_4cec721205f847bc83ed9703c7e55f4f_Out_2, _Smoothstep_a9b7ff11a107421bb0c85a2f432da89b_Out_3, _Multiply_11161919d70a4677afa5464991e82604_Out_2);
            float _Multiply_fa3b80bb520746589d1a1fbad510a77c_Out_2;
            Unity_Multiply_float_float(_SampleTexture2D_59795b66471740a39814ec94d2056178_R_4, _Multiply_11161919d70a4677afa5464991e82604_Out_2, _Multiply_fa3b80bb520746589d1a1fbad510a77c_Out_2);
            float _Property_677f641e9b8544658c10e5d5ee43e798_Out_0 = _CutOut;
            float _Step_7b58b826ad084a21a5279ceb77a87537_Out_2;
            Unity_Step_float(_Multiply_fa3b80bb520746589d1a1fbad510a77c_Out_2, _Property_677f641e9b8544658c10e5d5ee43e798_Out_0, _Step_7b58b826ad084a21a5279ceb77a87537_Out_2);
            float _OneMinus_4d55020d5bc240ec88662fc8676a8545_Out_1;
            Unity_OneMinus_float(_Step_7b58b826ad084a21a5279ceb77a87537_Out_2, _OneMinus_4d55020d5bc240ec88662fc8676a8545_Out_1);
            float4 _Property_4e04027d2f264a7e996c0f86a92319e4_Out_0 = _InColor;
            float4 _Multiply_224c206ab753483fb0424db29547e269_Out_2;
            Unity_Multiply_float4_float4((_OneMinus_4d55020d5bc240ec88662fc8676a8545_Out_1.xxxx), _Property_4e04027d2f264a7e996c0f86a92319e4_Out_0, _Multiply_224c206ab753483fb0424db29547e269_Out_2);
            float _Split_24e01fca92e949eba7a6774c29fe137c_R_1 = _Multiply_224c206ab753483fb0424db29547e269_Out_2[0];
            float _Split_24e01fca92e949eba7a6774c29fe137c_G_2 = _Multiply_224c206ab753483fb0424db29547e269_Out_2[1];
            float _Split_24e01fca92e949eba7a6774c29fe137c_B_3 = _Multiply_224c206ab753483fb0424db29547e269_Out_2[2];
            float _Split_24e01fca92e949eba7a6774c29fe137c_A_4 = _Multiply_224c206ab753483fb0424db29547e269_Out_2[3];
            float3 _Vector3_56713135973e4678aa995ed888d16058_Out_0 = float3(_Split_24e01fca92e949eba7a6774c29fe137c_R_1, _Split_24e01fca92e949eba7a6774c29fe137c_G_2, _Split_24e01fca92e949eba7a6774c29fe137c_B_3);
            float4 _Property_8ac41d77650a4e60ba7ae43021efb78f_Out_0 = _OutColor;
            float4 _Multiply_8ebc8d8c877446358817ceb37c0b7aa2_Out_2;
            Unity_Multiply_float4_float4((_Step_7b58b826ad084a21a5279ceb77a87537_Out_2.xxxx), _Property_8ac41d77650a4e60ba7ae43021efb78f_Out_0, _Multiply_8ebc8d8c877446358817ceb37c0b7aa2_Out_2);
            float4 _Property_e4c4a599ef4b42de9a2cd94b6249d668_Out_0 = _OutColor;
            float4 _Multiply_1c3c16ca738543088ccfb4b245310f5f_Out_2;
            Unity_Multiply_float4_float4(_Multiply_8ebc8d8c877446358817ceb37c0b7aa2_Out_2, _Property_e4c4a599ef4b42de9a2cd94b6249d668_Out_0, _Multiply_1c3c16ca738543088ccfb4b245310f5f_Out_2);
            float _Split_c8253fd439714b94a75cb2a77a77b722_R_1 = _Multiply_1c3c16ca738543088ccfb4b245310f5f_Out_2[0];
            float _Split_c8253fd439714b94a75cb2a77a77b722_G_2 = _Multiply_1c3c16ca738543088ccfb4b245310f5f_Out_2[1];
            float _Split_c8253fd439714b94a75cb2a77a77b722_B_3 = _Multiply_1c3c16ca738543088ccfb4b245310f5f_Out_2[2];
            float _Split_c8253fd439714b94a75cb2a77a77b722_A_4 = _Multiply_1c3c16ca738543088ccfb4b245310f5f_Out_2[3];
            float3 _Vector3_617455f31bcf4ebf83f017a09683f991_Out_0 = float3(_Split_c8253fd439714b94a75cb2a77a77b722_R_1, _Split_c8253fd439714b94a75cb2a77a77b722_G_2, _Split_c8253fd439714b94a75cb2a77a77b722_B_3);
            float3 _Add_870eff35413643e78d878bb6a265d2b3_Out_2;
            Unity_Add_float3(_Vector3_56713135973e4678aa995ed888d16058_Out_0, _Vector3_617455f31bcf4ebf83f017a09683f991_Out_0, _Add_870eff35413643e78d878bb6a265d2b3_Out_2);
            float _Add_2ff036f4d91e4ad9b7966b952924f758_Out_2;
            Unity_Add_float(_Split_24e01fca92e949eba7a6774c29fe137c_A_4, _Split_c8253fd439714b94a75cb2a77a77b722_A_4, _Add_2ff036f4d91e4ad9b7966b952924f758_Out_2);
            surface.BaseColor = _Add_870eff35413643e78d878bb6a265d2b3_Out_2;
            surface.Alpha = _Add_2ff036f4d91e4ad9b7966b952924f758_Out_2;
            return surface;
        }
        
            // --------------------------------------------------
            // Build Graph Inputs
        
            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        
            return output;
        }
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
            
        
        
        
        
        
            output.ObjectSpacePosition =                        TransformWorldToObject(input.positionWS);
            output.uv0 =                                        input.texCoord0;
            output.TimeParameters =                             _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN                output.FaceSign =                                   IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
            return output;
        }
        
            // --------------------------------------------------
            // Main
        
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/2D/ShaderGraph/Includes/SpriteUnlitPass.hlsl"
        
            ENDHLSL
        }
        Pass
        {
            Name "SceneSelectionPass"
            Tags
            {
                "LightMode" = "SceneSelectionPass"
            }
        
            // Render State
            Cull Off
        
            // Debug
            // <None>
        
            // --------------------------------------------------
            // Pass
        
            HLSLPROGRAM
        
            // Pragmas
            #pragma target 2.0
        #pragma exclude_renderers d3d11_9x
        #pragma vertex vert
        #pragma fragment frag
        
            // DotsInstancingOptions: <None>
            // HybridV1InjectedBuiltinProperties: <None>
        
            // Keywords
            // PassKeywords: <None>
            // GraphKeywords: <None>
        
            // Defines
            #define _SURFACE_TYPE_TRANSPARENT 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define VARYINGS_NEED_POSITION_WS
            #define VARYINGS_NEED_TEXCOORD0
            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_DEPTHONLY
        #define SCENESELECTIONPASS 1
        
            /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
            // Includes
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreInclude' */
        
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
            // --------------------------------------------------
            // Structs and Packing
        
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
            struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float4 texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 ObjectSpacePosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
             float4 interp1 : INTERP1;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
            PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyzw =  input.texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            output.texCoord0 = input.interp1.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
            // --------------------------------------------------
            // Graph
        
            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
        float2 _Speed;
        float _FadeAngle;
        float4 _OutColor;
        float4 _MainTex_TexelSize;
        float _CutOut;
        float4 _InColor;
        float _Fineness;
        float _FadeStart;
        float _FadeEnd;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_MainTex);
        SAMPLER(sampler_MainTex);
        
            // Graph Includes
            // GraphIncludes: <None>
        
            // -- Property used by ScenePickingPass
            #ifdef SCENEPICKINGPASS
            float4 _SelectionID;
            #endif
        
            // -- Properties used by SceneSelectionPass
            #ifdef SCENESELECTIONPASS
            int _ObjectId;
            int _PassValue;
            #endif
        
            // Graph Functions
            
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_Fraction_float2(float2 In, out float2 Out)
        {
            Out = frac(In);
        }
        
        void Unity_Step_float(float Edge, float In, out float Out)
        {
            Out = step(Edge, In);
        }
        
        void Unity_Rotate_Degrees_float(float2 UV, float2 Center, float Rotation, out float2 Out)
        {
            //rotation matrix
            Rotation = Rotation * (3.1415926f/180.0f);
            UV -= Center;
            float s = sin(Rotation);
            float c = cos(Rotation);
        
            //center rotation matrix
            float2x2 rMatrix = float2x2(c, -s, s, c);
            rMatrix *= 0.5;
            rMatrix += 0.5;
            rMatrix = rMatrix*2 - 1;
        
            //multiply the UVs by the rotation matrix
            UV.xy = mul(UV.xy, rMatrix);
            UV += Center;
        
            Out = UV;
        }
        
        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
            // Graph Vertex
            struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
            #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
            // Graph Pixel
            struct SurfaceDescription
        {
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_c1246444df68471ca9c2cf4c05d44a7f_Out_0 = UnityBuildTexture2DStructNoScale(_MainTex);
            float _Property_c45f657fa12d465288bfb9a8abe7e0c7_Out_0 = _Fineness;
            float3 _Multiply_3c38c1bff1b24fdabe33a7c9a5368f47_Out_2;
            Unity_Multiply_float3_float3(IN.ObjectSpacePosition, (_Property_c45f657fa12d465288bfb9a8abe7e0c7_Out_0.xxx), _Multiply_3c38c1bff1b24fdabe33a7c9a5368f47_Out_2);
            float2 _Property_6bf3322506034db480e189df64741c4b_Out_0 = _Speed;
            float2 _Multiply_d5bc2af014fb4e1984423be16e940dae_Out_2;
            Unity_Multiply_float2_float2((IN.TimeParameters.x.xx), _Property_6bf3322506034db480e189df64741c4b_Out_0, _Multiply_d5bc2af014fb4e1984423be16e940dae_Out_2);
            float2 _TilingAndOffset_31ff98aece294bfb8c46c8833c23721c_Out_3;
            Unity_TilingAndOffset_float((_Multiply_3c38c1bff1b24fdabe33a7c9a5368f47_Out_2.xy), float2 (0.01, 0.01), _Multiply_d5bc2af014fb4e1984423be16e940dae_Out_2, _TilingAndOffset_31ff98aece294bfb8c46c8833c23721c_Out_3);
            float2 _Fraction_ddd49d606aa64e98818684e1f5ca2a4b_Out_1;
            Unity_Fraction_float2(_TilingAndOffset_31ff98aece294bfb8c46c8833c23721c_Out_3, _Fraction_ddd49d606aa64e98818684e1f5ca2a4b_Out_1);
            float4 _SampleTexture2D_59795b66471740a39814ec94d2056178_RGBA_0 = SAMPLE_TEXTURE2D(_Property_c1246444df68471ca9c2cf4c05d44a7f_Out_0.tex, _Property_c1246444df68471ca9c2cf4c05d44a7f_Out_0.samplerstate, _Property_c1246444df68471ca9c2cf4c05d44a7f_Out_0.GetTransformedUV(_Fraction_ddd49d606aa64e98818684e1f5ca2a4b_Out_1));
            float _SampleTexture2D_59795b66471740a39814ec94d2056178_R_4 = _SampleTexture2D_59795b66471740a39814ec94d2056178_RGBA_0.r;
            float _SampleTexture2D_59795b66471740a39814ec94d2056178_G_5 = _SampleTexture2D_59795b66471740a39814ec94d2056178_RGBA_0.g;
            float _SampleTexture2D_59795b66471740a39814ec94d2056178_B_6 = _SampleTexture2D_59795b66471740a39814ec94d2056178_RGBA_0.b;
            float _SampleTexture2D_59795b66471740a39814ec94d2056178_A_7 = _SampleTexture2D_59795b66471740a39814ec94d2056178_RGBA_0.a;
            float _Property_245e5fad73664cf48bdabc8e401deac4_Out_0 = _CutOut;
            float _Step_4cec721205f847bc83ed9703c7e55f4f_Out_2;
            Unity_Step_float(_Property_245e5fad73664cf48bdabc8e401deac4_Out_0, _SampleTexture2D_59795b66471740a39814ec94d2056178_R_4, _Step_4cec721205f847bc83ed9703c7e55f4f_Out_2);
            float _Property_8fab37fa17404320acbb12bcdf8ab86c_Out_0 = _FadeStart;
            float _Property_8342fbde3d9c4d869e9a3c0b47bcb505_Out_0 = _FadeEnd;
            float _Property_9b787bff13fb4bfb8c1990460838cc47_Out_0 = _FadeAngle;
            float2 _Rotate_0fc591d64b9e4fe6bd24accc72eedb35_Out_3;
            Unity_Rotate_Degrees_float(IN.uv0.xy, float2 (0.5, 0.5), _Property_9b787bff13fb4bfb8c1990460838cc47_Out_0, _Rotate_0fc591d64b9e4fe6bd24accc72eedb35_Out_3);
            float _Split_2fb787a8ca3b491da2cceb170763c878_R_1 = _Rotate_0fc591d64b9e4fe6bd24accc72eedb35_Out_3[0];
            float _Split_2fb787a8ca3b491da2cceb170763c878_G_2 = _Rotate_0fc591d64b9e4fe6bd24accc72eedb35_Out_3[1];
            float _Split_2fb787a8ca3b491da2cceb170763c878_B_3 = 0;
            float _Split_2fb787a8ca3b491da2cceb170763c878_A_4 = 0;
            float _Smoothstep_a9b7ff11a107421bb0c85a2f432da89b_Out_3;
            Unity_Smoothstep_float(_Property_8fab37fa17404320acbb12bcdf8ab86c_Out_0, _Property_8342fbde3d9c4d869e9a3c0b47bcb505_Out_0, _Split_2fb787a8ca3b491da2cceb170763c878_R_1, _Smoothstep_a9b7ff11a107421bb0c85a2f432da89b_Out_3);
            float _Multiply_11161919d70a4677afa5464991e82604_Out_2;
            Unity_Multiply_float_float(_Step_4cec721205f847bc83ed9703c7e55f4f_Out_2, _Smoothstep_a9b7ff11a107421bb0c85a2f432da89b_Out_3, _Multiply_11161919d70a4677afa5464991e82604_Out_2);
            float _Multiply_fa3b80bb520746589d1a1fbad510a77c_Out_2;
            Unity_Multiply_float_float(_SampleTexture2D_59795b66471740a39814ec94d2056178_R_4, _Multiply_11161919d70a4677afa5464991e82604_Out_2, _Multiply_fa3b80bb520746589d1a1fbad510a77c_Out_2);
            float _Property_677f641e9b8544658c10e5d5ee43e798_Out_0 = _CutOut;
            float _Step_7b58b826ad084a21a5279ceb77a87537_Out_2;
            Unity_Step_float(_Multiply_fa3b80bb520746589d1a1fbad510a77c_Out_2, _Property_677f641e9b8544658c10e5d5ee43e798_Out_0, _Step_7b58b826ad084a21a5279ceb77a87537_Out_2);
            float _OneMinus_4d55020d5bc240ec88662fc8676a8545_Out_1;
            Unity_OneMinus_float(_Step_7b58b826ad084a21a5279ceb77a87537_Out_2, _OneMinus_4d55020d5bc240ec88662fc8676a8545_Out_1);
            float4 _Property_4e04027d2f264a7e996c0f86a92319e4_Out_0 = _InColor;
            float4 _Multiply_224c206ab753483fb0424db29547e269_Out_2;
            Unity_Multiply_float4_float4((_OneMinus_4d55020d5bc240ec88662fc8676a8545_Out_1.xxxx), _Property_4e04027d2f264a7e996c0f86a92319e4_Out_0, _Multiply_224c206ab753483fb0424db29547e269_Out_2);
            float _Split_24e01fca92e949eba7a6774c29fe137c_R_1 = _Multiply_224c206ab753483fb0424db29547e269_Out_2[0];
            float _Split_24e01fca92e949eba7a6774c29fe137c_G_2 = _Multiply_224c206ab753483fb0424db29547e269_Out_2[1];
            float _Split_24e01fca92e949eba7a6774c29fe137c_B_3 = _Multiply_224c206ab753483fb0424db29547e269_Out_2[2];
            float _Split_24e01fca92e949eba7a6774c29fe137c_A_4 = _Multiply_224c206ab753483fb0424db29547e269_Out_2[3];
            float4 _Property_8ac41d77650a4e60ba7ae43021efb78f_Out_0 = _OutColor;
            float4 _Multiply_8ebc8d8c877446358817ceb37c0b7aa2_Out_2;
            Unity_Multiply_float4_float4((_Step_7b58b826ad084a21a5279ceb77a87537_Out_2.xxxx), _Property_8ac41d77650a4e60ba7ae43021efb78f_Out_0, _Multiply_8ebc8d8c877446358817ceb37c0b7aa2_Out_2);
            float4 _Property_e4c4a599ef4b42de9a2cd94b6249d668_Out_0 = _OutColor;
            float4 _Multiply_1c3c16ca738543088ccfb4b245310f5f_Out_2;
            Unity_Multiply_float4_float4(_Multiply_8ebc8d8c877446358817ceb37c0b7aa2_Out_2, _Property_e4c4a599ef4b42de9a2cd94b6249d668_Out_0, _Multiply_1c3c16ca738543088ccfb4b245310f5f_Out_2);
            float _Split_c8253fd439714b94a75cb2a77a77b722_R_1 = _Multiply_1c3c16ca738543088ccfb4b245310f5f_Out_2[0];
            float _Split_c8253fd439714b94a75cb2a77a77b722_G_2 = _Multiply_1c3c16ca738543088ccfb4b245310f5f_Out_2[1];
            float _Split_c8253fd439714b94a75cb2a77a77b722_B_3 = _Multiply_1c3c16ca738543088ccfb4b245310f5f_Out_2[2];
            float _Split_c8253fd439714b94a75cb2a77a77b722_A_4 = _Multiply_1c3c16ca738543088ccfb4b245310f5f_Out_2[3];
            float _Add_2ff036f4d91e4ad9b7966b952924f758_Out_2;
            Unity_Add_float(_Split_24e01fca92e949eba7a6774c29fe137c_A_4, _Split_c8253fd439714b94a75cb2a77a77b722_A_4, _Add_2ff036f4d91e4ad9b7966b952924f758_Out_2);
            surface.Alpha = _Add_2ff036f4d91e4ad9b7966b952924f758_Out_2;
            return surface;
        }
        
            // --------------------------------------------------
            // Build Graph Inputs
        
            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        
            return output;
        }
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
            
        
        
        
        
        
            output.ObjectSpacePosition =                        TransformWorldToObject(input.positionWS);
            output.uv0 =                                        input.texCoord0;
            output.TimeParameters =                             _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN                output.FaceSign =                                   IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
            return output;
        }
        
            // --------------------------------------------------
            // Main
        
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"
        
            ENDHLSL
        }
        Pass
        {
            Name "ScenePickingPass"
            Tags
            {
                "LightMode" = "Picking"
            }
        
            // Render State
            Cull Back
        
            // Debug
            // <None>
        
            // --------------------------------------------------
            // Pass
        
            HLSLPROGRAM
        
            // Pragmas
            #pragma target 2.0
        #pragma exclude_renderers d3d11_9x
        #pragma vertex vert
        #pragma fragment frag
        
            // DotsInstancingOptions: <None>
            // HybridV1InjectedBuiltinProperties: <None>
        
            // Keywords
            // PassKeywords: <None>
            // GraphKeywords: <None>
        
            // Defines
            #define _SURFACE_TYPE_TRANSPARENT 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define VARYINGS_NEED_POSITION_WS
            #define VARYINGS_NEED_TEXCOORD0
            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_DEPTHONLY
        #define SCENEPICKINGPASS 1
        
            /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
            // Includes
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreInclude' */
        
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
            // --------------------------------------------------
            // Structs and Packing
        
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
            struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float4 texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 ObjectSpacePosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
             float4 interp1 : INTERP1;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
            PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyzw =  input.texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            output.texCoord0 = input.interp1.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
            // --------------------------------------------------
            // Graph
        
            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
        float2 _Speed;
        float _FadeAngle;
        float4 _OutColor;
        float4 _MainTex_TexelSize;
        float _CutOut;
        float4 _InColor;
        float _Fineness;
        float _FadeStart;
        float _FadeEnd;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_MainTex);
        SAMPLER(sampler_MainTex);
        
            // Graph Includes
            // GraphIncludes: <None>
        
            // -- Property used by ScenePickingPass
            #ifdef SCENEPICKINGPASS
            float4 _SelectionID;
            #endif
        
            // -- Properties used by SceneSelectionPass
            #ifdef SCENESELECTIONPASS
            int _ObjectId;
            int _PassValue;
            #endif
        
            // Graph Functions
            
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_Fraction_float2(float2 In, out float2 Out)
        {
            Out = frac(In);
        }
        
        void Unity_Step_float(float Edge, float In, out float Out)
        {
            Out = step(Edge, In);
        }
        
        void Unity_Rotate_Degrees_float(float2 UV, float2 Center, float Rotation, out float2 Out)
        {
            //rotation matrix
            Rotation = Rotation * (3.1415926f/180.0f);
            UV -= Center;
            float s = sin(Rotation);
            float c = cos(Rotation);
        
            //center rotation matrix
            float2x2 rMatrix = float2x2(c, -s, s, c);
            rMatrix *= 0.5;
            rMatrix += 0.5;
            rMatrix = rMatrix*2 - 1;
        
            //multiply the UVs by the rotation matrix
            UV.xy = mul(UV.xy, rMatrix);
            UV += Center;
        
            Out = UV;
        }
        
        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
            // Graph Vertex
            struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
            #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
            // Graph Pixel
            struct SurfaceDescription
        {
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_c1246444df68471ca9c2cf4c05d44a7f_Out_0 = UnityBuildTexture2DStructNoScale(_MainTex);
            float _Property_c45f657fa12d465288bfb9a8abe7e0c7_Out_0 = _Fineness;
            float3 _Multiply_3c38c1bff1b24fdabe33a7c9a5368f47_Out_2;
            Unity_Multiply_float3_float3(IN.ObjectSpacePosition, (_Property_c45f657fa12d465288bfb9a8abe7e0c7_Out_0.xxx), _Multiply_3c38c1bff1b24fdabe33a7c9a5368f47_Out_2);
            float2 _Property_6bf3322506034db480e189df64741c4b_Out_0 = _Speed;
            float2 _Multiply_d5bc2af014fb4e1984423be16e940dae_Out_2;
            Unity_Multiply_float2_float2((IN.TimeParameters.x.xx), _Property_6bf3322506034db480e189df64741c4b_Out_0, _Multiply_d5bc2af014fb4e1984423be16e940dae_Out_2);
            float2 _TilingAndOffset_31ff98aece294bfb8c46c8833c23721c_Out_3;
            Unity_TilingAndOffset_float((_Multiply_3c38c1bff1b24fdabe33a7c9a5368f47_Out_2.xy), float2 (0.01, 0.01), _Multiply_d5bc2af014fb4e1984423be16e940dae_Out_2, _TilingAndOffset_31ff98aece294bfb8c46c8833c23721c_Out_3);
            float2 _Fraction_ddd49d606aa64e98818684e1f5ca2a4b_Out_1;
            Unity_Fraction_float2(_TilingAndOffset_31ff98aece294bfb8c46c8833c23721c_Out_3, _Fraction_ddd49d606aa64e98818684e1f5ca2a4b_Out_1);
            float4 _SampleTexture2D_59795b66471740a39814ec94d2056178_RGBA_0 = SAMPLE_TEXTURE2D(_Property_c1246444df68471ca9c2cf4c05d44a7f_Out_0.tex, _Property_c1246444df68471ca9c2cf4c05d44a7f_Out_0.samplerstate, _Property_c1246444df68471ca9c2cf4c05d44a7f_Out_0.GetTransformedUV(_Fraction_ddd49d606aa64e98818684e1f5ca2a4b_Out_1));
            float _SampleTexture2D_59795b66471740a39814ec94d2056178_R_4 = _SampleTexture2D_59795b66471740a39814ec94d2056178_RGBA_0.r;
            float _SampleTexture2D_59795b66471740a39814ec94d2056178_G_5 = _SampleTexture2D_59795b66471740a39814ec94d2056178_RGBA_0.g;
            float _SampleTexture2D_59795b66471740a39814ec94d2056178_B_6 = _SampleTexture2D_59795b66471740a39814ec94d2056178_RGBA_0.b;
            float _SampleTexture2D_59795b66471740a39814ec94d2056178_A_7 = _SampleTexture2D_59795b66471740a39814ec94d2056178_RGBA_0.a;
            float _Property_245e5fad73664cf48bdabc8e401deac4_Out_0 = _CutOut;
            float _Step_4cec721205f847bc83ed9703c7e55f4f_Out_2;
            Unity_Step_float(_Property_245e5fad73664cf48bdabc8e401deac4_Out_0, _SampleTexture2D_59795b66471740a39814ec94d2056178_R_4, _Step_4cec721205f847bc83ed9703c7e55f4f_Out_2);
            float _Property_8fab37fa17404320acbb12bcdf8ab86c_Out_0 = _FadeStart;
            float _Property_8342fbde3d9c4d869e9a3c0b47bcb505_Out_0 = _FadeEnd;
            float _Property_9b787bff13fb4bfb8c1990460838cc47_Out_0 = _FadeAngle;
            float2 _Rotate_0fc591d64b9e4fe6bd24accc72eedb35_Out_3;
            Unity_Rotate_Degrees_float(IN.uv0.xy, float2 (0.5, 0.5), _Property_9b787bff13fb4bfb8c1990460838cc47_Out_0, _Rotate_0fc591d64b9e4fe6bd24accc72eedb35_Out_3);
            float _Split_2fb787a8ca3b491da2cceb170763c878_R_1 = _Rotate_0fc591d64b9e4fe6bd24accc72eedb35_Out_3[0];
            float _Split_2fb787a8ca3b491da2cceb170763c878_G_2 = _Rotate_0fc591d64b9e4fe6bd24accc72eedb35_Out_3[1];
            float _Split_2fb787a8ca3b491da2cceb170763c878_B_3 = 0;
            float _Split_2fb787a8ca3b491da2cceb170763c878_A_4 = 0;
            float _Smoothstep_a9b7ff11a107421bb0c85a2f432da89b_Out_3;
            Unity_Smoothstep_float(_Property_8fab37fa17404320acbb12bcdf8ab86c_Out_0, _Property_8342fbde3d9c4d869e9a3c0b47bcb505_Out_0, _Split_2fb787a8ca3b491da2cceb170763c878_R_1, _Smoothstep_a9b7ff11a107421bb0c85a2f432da89b_Out_3);
            float _Multiply_11161919d70a4677afa5464991e82604_Out_2;
            Unity_Multiply_float_float(_Step_4cec721205f847bc83ed9703c7e55f4f_Out_2, _Smoothstep_a9b7ff11a107421bb0c85a2f432da89b_Out_3, _Multiply_11161919d70a4677afa5464991e82604_Out_2);
            float _Multiply_fa3b80bb520746589d1a1fbad510a77c_Out_2;
            Unity_Multiply_float_float(_SampleTexture2D_59795b66471740a39814ec94d2056178_R_4, _Multiply_11161919d70a4677afa5464991e82604_Out_2, _Multiply_fa3b80bb520746589d1a1fbad510a77c_Out_2);
            float _Property_677f641e9b8544658c10e5d5ee43e798_Out_0 = _CutOut;
            float _Step_7b58b826ad084a21a5279ceb77a87537_Out_2;
            Unity_Step_float(_Multiply_fa3b80bb520746589d1a1fbad510a77c_Out_2, _Property_677f641e9b8544658c10e5d5ee43e798_Out_0, _Step_7b58b826ad084a21a5279ceb77a87537_Out_2);
            float _OneMinus_4d55020d5bc240ec88662fc8676a8545_Out_1;
            Unity_OneMinus_float(_Step_7b58b826ad084a21a5279ceb77a87537_Out_2, _OneMinus_4d55020d5bc240ec88662fc8676a8545_Out_1);
            float4 _Property_4e04027d2f264a7e996c0f86a92319e4_Out_0 = _InColor;
            float4 _Multiply_224c206ab753483fb0424db29547e269_Out_2;
            Unity_Multiply_float4_float4((_OneMinus_4d55020d5bc240ec88662fc8676a8545_Out_1.xxxx), _Property_4e04027d2f264a7e996c0f86a92319e4_Out_0, _Multiply_224c206ab753483fb0424db29547e269_Out_2);
            float _Split_24e01fca92e949eba7a6774c29fe137c_R_1 = _Multiply_224c206ab753483fb0424db29547e269_Out_2[0];
            float _Split_24e01fca92e949eba7a6774c29fe137c_G_2 = _Multiply_224c206ab753483fb0424db29547e269_Out_2[1];
            float _Split_24e01fca92e949eba7a6774c29fe137c_B_3 = _Multiply_224c206ab753483fb0424db29547e269_Out_2[2];
            float _Split_24e01fca92e949eba7a6774c29fe137c_A_4 = _Multiply_224c206ab753483fb0424db29547e269_Out_2[3];
            float4 _Property_8ac41d77650a4e60ba7ae43021efb78f_Out_0 = _OutColor;
            float4 _Multiply_8ebc8d8c877446358817ceb37c0b7aa2_Out_2;
            Unity_Multiply_float4_float4((_Step_7b58b826ad084a21a5279ceb77a87537_Out_2.xxxx), _Property_8ac41d77650a4e60ba7ae43021efb78f_Out_0, _Multiply_8ebc8d8c877446358817ceb37c0b7aa2_Out_2);
            float4 _Property_e4c4a599ef4b42de9a2cd94b6249d668_Out_0 = _OutColor;
            float4 _Multiply_1c3c16ca738543088ccfb4b245310f5f_Out_2;
            Unity_Multiply_float4_float4(_Multiply_8ebc8d8c877446358817ceb37c0b7aa2_Out_2, _Property_e4c4a599ef4b42de9a2cd94b6249d668_Out_0, _Multiply_1c3c16ca738543088ccfb4b245310f5f_Out_2);
            float _Split_c8253fd439714b94a75cb2a77a77b722_R_1 = _Multiply_1c3c16ca738543088ccfb4b245310f5f_Out_2[0];
            float _Split_c8253fd439714b94a75cb2a77a77b722_G_2 = _Multiply_1c3c16ca738543088ccfb4b245310f5f_Out_2[1];
            float _Split_c8253fd439714b94a75cb2a77a77b722_B_3 = _Multiply_1c3c16ca738543088ccfb4b245310f5f_Out_2[2];
            float _Split_c8253fd439714b94a75cb2a77a77b722_A_4 = _Multiply_1c3c16ca738543088ccfb4b245310f5f_Out_2[3];
            float _Add_2ff036f4d91e4ad9b7966b952924f758_Out_2;
            Unity_Add_float(_Split_24e01fca92e949eba7a6774c29fe137c_A_4, _Split_c8253fd439714b94a75cb2a77a77b722_A_4, _Add_2ff036f4d91e4ad9b7966b952924f758_Out_2);
            surface.Alpha = _Add_2ff036f4d91e4ad9b7966b952924f758_Out_2;
            return surface;
        }
        
            // --------------------------------------------------
            // Build Graph Inputs
        
            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        
            return output;
        }
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
            
        
        
        
        
        
            output.ObjectSpacePosition =                        TransformWorldToObject(input.positionWS);
            output.uv0 =                                        input.texCoord0;
            output.TimeParameters =                             _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN                output.FaceSign =                                   IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
            return output;
        }
        
            // --------------------------------------------------
            // Main
        
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"
        
            ENDHLSL
        }
        Pass
        {
            Name "Sprite Unlit"
            Tags
            {
                "LightMode" = "UniversalForward"
            }
        
            // Render State
            Cull Off
        Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
        ZTest LEqual
        ZWrite Off
        
            // Debug
            // <None>
        
            // --------------------------------------------------
            // Pass
        
            HLSLPROGRAM
        
            // Pragmas
            #pragma target 2.0
        #pragma exclude_renderers d3d11_9x
        #pragma vertex vert
        #pragma fragment frag
        
            // DotsInstancingOptions: <None>
            // HybridV1InjectedBuiltinProperties: <None>
        
            // Keywords
            #pragma multi_compile_fragment _ DEBUG_DISPLAY
            // GraphKeywords: <None>
        
            // Defines
            #define _SURFACE_TYPE_TRANSPARENT 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define ATTRIBUTES_NEED_COLOR
            #define VARYINGS_NEED_POSITION_WS
            #define VARYINGS_NEED_TEXCOORD0
            #define VARYINGS_NEED_COLOR
            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_SPRITEFORWARD
            /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
            // Includes
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreInclude' */
        
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
            // --------------------------------------------------
            // Structs and Packing
        
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
            struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 color : COLOR;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float4 texCoord0;
             float4 color;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 ObjectSpacePosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
             float4 interp1 : INTERP1;
             float4 interp2 : INTERP2;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
            PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyzw =  input.texCoord0;
            output.interp2.xyzw =  input.color;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            output.texCoord0 = input.interp1.xyzw;
            output.color = input.interp2.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
            // --------------------------------------------------
            // Graph
        
            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
        float2 _Speed;
        float _FadeAngle;
        float4 _OutColor;
        float4 _MainTex_TexelSize;
        float _CutOut;
        float4 _InColor;
        float _Fineness;
        float _FadeStart;
        float _FadeEnd;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_MainTex);
        SAMPLER(sampler_MainTex);
        
            // Graph Includes
            // GraphIncludes: <None>
        
            // -- Property used by ScenePickingPass
            #ifdef SCENEPICKINGPASS
            float4 _SelectionID;
            #endif
        
            // -- Properties used by SceneSelectionPass
            #ifdef SCENESELECTIONPASS
            int _ObjectId;
            int _PassValue;
            #endif
        
            // Graph Functions
            
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_Fraction_float2(float2 In, out float2 Out)
        {
            Out = frac(In);
        }
        
        void Unity_Step_float(float Edge, float In, out float Out)
        {
            Out = step(Edge, In);
        }
        
        void Unity_Rotate_Degrees_float(float2 UV, float2 Center, float Rotation, out float2 Out)
        {
            //rotation matrix
            Rotation = Rotation * (3.1415926f/180.0f);
            UV -= Center;
            float s = sin(Rotation);
            float c = cos(Rotation);
        
            //center rotation matrix
            float2x2 rMatrix = float2x2(c, -s, s, c);
            rMatrix *= 0.5;
            rMatrix += 0.5;
            rMatrix = rMatrix*2 - 1;
        
            //multiply the UVs by the rotation matrix
            UV.xy = mul(UV.xy, rMatrix);
            UV += Center;
        
            Out = UV;
        }
        
        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
            // Graph Vertex
            struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
            #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
            // Graph Pixel
            struct SurfaceDescription
        {
            float3 BaseColor;
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_c1246444df68471ca9c2cf4c05d44a7f_Out_0 = UnityBuildTexture2DStructNoScale(_MainTex);
            float _Property_c45f657fa12d465288bfb9a8abe7e0c7_Out_0 = _Fineness;
            float3 _Multiply_3c38c1bff1b24fdabe33a7c9a5368f47_Out_2;
            Unity_Multiply_float3_float3(IN.ObjectSpacePosition, (_Property_c45f657fa12d465288bfb9a8abe7e0c7_Out_0.xxx), _Multiply_3c38c1bff1b24fdabe33a7c9a5368f47_Out_2);
            float2 _Property_6bf3322506034db480e189df64741c4b_Out_0 = _Speed;
            float2 _Multiply_d5bc2af014fb4e1984423be16e940dae_Out_2;
            Unity_Multiply_float2_float2((IN.TimeParameters.x.xx), _Property_6bf3322506034db480e189df64741c4b_Out_0, _Multiply_d5bc2af014fb4e1984423be16e940dae_Out_2);
            float2 _TilingAndOffset_31ff98aece294bfb8c46c8833c23721c_Out_3;
            Unity_TilingAndOffset_float((_Multiply_3c38c1bff1b24fdabe33a7c9a5368f47_Out_2.xy), float2 (0.01, 0.01), _Multiply_d5bc2af014fb4e1984423be16e940dae_Out_2, _TilingAndOffset_31ff98aece294bfb8c46c8833c23721c_Out_3);
            float2 _Fraction_ddd49d606aa64e98818684e1f5ca2a4b_Out_1;
            Unity_Fraction_float2(_TilingAndOffset_31ff98aece294bfb8c46c8833c23721c_Out_3, _Fraction_ddd49d606aa64e98818684e1f5ca2a4b_Out_1);
            float4 _SampleTexture2D_59795b66471740a39814ec94d2056178_RGBA_0 = SAMPLE_TEXTURE2D(_Property_c1246444df68471ca9c2cf4c05d44a7f_Out_0.tex, _Property_c1246444df68471ca9c2cf4c05d44a7f_Out_0.samplerstate, _Property_c1246444df68471ca9c2cf4c05d44a7f_Out_0.GetTransformedUV(_Fraction_ddd49d606aa64e98818684e1f5ca2a4b_Out_1));
            float _SampleTexture2D_59795b66471740a39814ec94d2056178_R_4 = _SampleTexture2D_59795b66471740a39814ec94d2056178_RGBA_0.r;
            float _SampleTexture2D_59795b66471740a39814ec94d2056178_G_5 = _SampleTexture2D_59795b66471740a39814ec94d2056178_RGBA_0.g;
            float _SampleTexture2D_59795b66471740a39814ec94d2056178_B_6 = _SampleTexture2D_59795b66471740a39814ec94d2056178_RGBA_0.b;
            float _SampleTexture2D_59795b66471740a39814ec94d2056178_A_7 = _SampleTexture2D_59795b66471740a39814ec94d2056178_RGBA_0.a;
            float _Property_245e5fad73664cf48bdabc8e401deac4_Out_0 = _CutOut;
            float _Step_4cec721205f847bc83ed9703c7e55f4f_Out_2;
            Unity_Step_float(_Property_245e5fad73664cf48bdabc8e401deac4_Out_0, _SampleTexture2D_59795b66471740a39814ec94d2056178_R_4, _Step_4cec721205f847bc83ed9703c7e55f4f_Out_2);
            float _Property_8fab37fa17404320acbb12bcdf8ab86c_Out_0 = _FadeStart;
            float _Property_8342fbde3d9c4d869e9a3c0b47bcb505_Out_0 = _FadeEnd;
            float _Property_9b787bff13fb4bfb8c1990460838cc47_Out_0 = _FadeAngle;
            float2 _Rotate_0fc591d64b9e4fe6bd24accc72eedb35_Out_3;
            Unity_Rotate_Degrees_float(IN.uv0.xy, float2 (0.5, 0.5), _Property_9b787bff13fb4bfb8c1990460838cc47_Out_0, _Rotate_0fc591d64b9e4fe6bd24accc72eedb35_Out_3);
            float _Split_2fb787a8ca3b491da2cceb170763c878_R_1 = _Rotate_0fc591d64b9e4fe6bd24accc72eedb35_Out_3[0];
            float _Split_2fb787a8ca3b491da2cceb170763c878_G_2 = _Rotate_0fc591d64b9e4fe6bd24accc72eedb35_Out_3[1];
            float _Split_2fb787a8ca3b491da2cceb170763c878_B_3 = 0;
            float _Split_2fb787a8ca3b491da2cceb170763c878_A_4 = 0;
            float _Smoothstep_a9b7ff11a107421bb0c85a2f432da89b_Out_3;
            Unity_Smoothstep_float(_Property_8fab37fa17404320acbb12bcdf8ab86c_Out_0, _Property_8342fbde3d9c4d869e9a3c0b47bcb505_Out_0, _Split_2fb787a8ca3b491da2cceb170763c878_R_1, _Smoothstep_a9b7ff11a107421bb0c85a2f432da89b_Out_3);
            float _Multiply_11161919d70a4677afa5464991e82604_Out_2;
            Unity_Multiply_float_float(_Step_4cec721205f847bc83ed9703c7e55f4f_Out_2, _Smoothstep_a9b7ff11a107421bb0c85a2f432da89b_Out_3, _Multiply_11161919d70a4677afa5464991e82604_Out_2);
            float _Multiply_fa3b80bb520746589d1a1fbad510a77c_Out_2;
            Unity_Multiply_float_float(_SampleTexture2D_59795b66471740a39814ec94d2056178_R_4, _Multiply_11161919d70a4677afa5464991e82604_Out_2, _Multiply_fa3b80bb520746589d1a1fbad510a77c_Out_2);
            float _Property_677f641e9b8544658c10e5d5ee43e798_Out_0 = _CutOut;
            float _Step_7b58b826ad084a21a5279ceb77a87537_Out_2;
            Unity_Step_float(_Multiply_fa3b80bb520746589d1a1fbad510a77c_Out_2, _Property_677f641e9b8544658c10e5d5ee43e798_Out_0, _Step_7b58b826ad084a21a5279ceb77a87537_Out_2);
            float _OneMinus_4d55020d5bc240ec88662fc8676a8545_Out_1;
            Unity_OneMinus_float(_Step_7b58b826ad084a21a5279ceb77a87537_Out_2, _OneMinus_4d55020d5bc240ec88662fc8676a8545_Out_1);
            float4 _Property_4e04027d2f264a7e996c0f86a92319e4_Out_0 = _InColor;
            float4 _Multiply_224c206ab753483fb0424db29547e269_Out_2;
            Unity_Multiply_float4_float4((_OneMinus_4d55020d5bc240ec88662fc8676a8545_Out_1.xxxx), _Property_4e04027d2f264a7e996c0f86a92319e4_Out_0, _Multiply_224c206ab753483fb0424db29547e269_Out_2);
            float _Split_24e01fca92e949eba7a6774c29fe137c_R_1 = _Multiply_224c206ab753483fb0424db29547e269_Out_2[0];
            float _Split_24e01fca92e949eba7a6774c29fe137c_G_2 = _Multiply_224c206ab753483fb0424db29547e269_Out_2[1];
            float _Split_24e01fca92e949eba7a6774c29fe137c_B_3 = _Multiply_224c206ab753483fb0424db29547e269_Out_2[2];
            float _Split_24e01fca92e949eba7a6774c29fe137c_A_4 = _Multiply_224c206ab753483fb0424db29547e269_Out_2[3];
            float3 _Vector3_56713135973e4678aa995ed888d16058_Out_0 = float3(_Split_24e01fca92e949eba7a6774c29fe137c_R_1, _Split_24e01fca92e949eba7a6774c29fe137c_G_2, _Split_24e01fca92e949eba7a6774c29fe137c_B_3);
            float4 _Property_8ac41d77650a4e60ba7ae43021efb78f_Out_0 = _OutColor;
            float4 _Multiply_8ebc8d8c877446358817ceb37c0b7aa2_Out_2;
            Unity_Multiply_float4_float4((_Step_7b58b826ad084a21a5279ceb77a87537_Out_2.xxxx), _Property_8ac41d77650a4e60ba7ae43021efb78f_Out_0, _Multiply_8ebc8d8c877446358817ceb37c0b7aa2_Out_2);
            float4 _Property_e4c4a599ef4b42de9a2cd94b6249d668_Out_0 = _OutColor;
            float4 _Multiply_1c3c16ca738543088ccfb4b245310f5f_Out_2;
            Unity_Multiply_float4_float4(_Multiply_8ebc8d8c877446358817ceb37c0b7aa2_Out_2, _Property_e4c4a599ef4b42de9a2cd94b6249d668_Out_0, _Multiply_1c3c16ca738543088ccfb4b245310f5f_Out_2);
            float _Split_c8253fd439714b94a75cb2a77a77b722_R_1 = _Multiply_1c3c16ca738543088ccfb4b245310f5f_Out_2[0];
            float _Split_c8253fd439714b94a75cb2a77a77b722_G_2 = _Multiply_1c3c16ca738543088ccfb4b245310f5f_Out_2[1];
            float _Split_c8253fd439714b94a75cb2a77a77b722_B_3 = _Multiply_1c3c16ca738543088ccfb4b245310f5f_Out_2[2];
            float _Split_c8253fd439714b94a75cb2a77a77b722_A_4 = _Multiply_1c3c16ca738543088ccfb4b245310f5f_Out_2[3];
            float3 _Vector3_617455f31bcf4ebf83f017a09683f991_Out_0 = float3(_Split_c8253fd439714b94a75cb2a77a77b722_R_1, _Split_c8253fd439714b94a75cb2a77a77b722_G_2, _Split_c8253fd439714b94a75cb2a77a77b722_B_3);
            float3 _Add_870eff35413643e78d878bb6a265d2b3_Out_2;
            Unity_Add_float3(_Vector3_56713135973e4678aa995ed888d16058_Out_0, _Vector3_617455f31bcf4ebf83f017a09683f991_Out_0, _Add_870eff35413643e78d878bb6a265d2b3_Out_2);
            float _Add_2ff036f4d91e4ad9b7966b952924f758_Out_2;
            Unity_Add_float(_Split_24e01fca92e949eba7a6774c29fe137c_A_4, _Split_c8253fd439714b94a75cb2a77a77b722_A_4, _Add_2ff036f4d91e4ad9b7966b952924f758_Out_2);
            surface.BaseColor = _Add_870eff35413643e78d878bb6a265d2b3_Out_2;
            surface.Alpha = _Add_2ff036f4d91e4ad9b7966b952924f758_Out_2;
            return surface;
        }
        
            // --------------------------------------------------
            // Build Graph Inputs
        
            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        
            return output;
        }
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
            
        
        
        
        
        
            output.ObjectSpacePosition =                        TransformWorldToObject(input.positionWS);
            output.uv0 =                                        input.texCoord0;
            output.TimeParameters =                             _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN                output.FaceSign =                                   IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
            return output;
        }
        
            // --------------------------------------------------
            // Main
        
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/2D/ShaderGraph/Includes/SpriteUnlitPass.hlsl"
        
            ENDHLSL
        }
    }
    CustomEditor "UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI"
    FallBack "Hidden/Shader Graph/FallbackError"
}