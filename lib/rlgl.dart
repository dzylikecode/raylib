// ignore_for_file: non_constant_identifier_names
//
// 本文件导出 rlgl 模块（底层 OpenGL 抽象层）。
//
// 大部分 rlgl 函数仅使用基础类型（int / double / bool），可直接导出。
// 需要指针/Matrix/RenderBatch 等复杂类型的函数先注释，后续按需封装。
//
// 不代理：
//   rlEnableStatePointer, rlDisableStatePointer — OpenGL 1.1 only，Dart 绑定未生成
//   rlLoadExtensions — 需要 void* loader，Dart 侧不需要手动调用

// ── Matrix operations ────────────────────────────────────────────────────
export 'src/raylib.g.dart' show rlMatrixMode;
export 'src/raylib.g.dart' show rlPushMatrix;
export 'src/raylib.g.dart' show rlPopMatrix;
export 'src/raylib.g.dart' show rlLoadIdentity;
export 'src/raylib.g.dart' show rlTranslatef;
export 'src/raylib.g.dart' show rlRotatef;
export 'src/raylib.g.dart' show rlScalef;
// export 'src/raylib.g.dart' show rlMultMatrixf;         // Pointer<Float>
export 'src/raylib.g.dart' show rlFrustum;
export 'src/raylib.g.dart' show rlOrtho;
export 'src/raylib.g.dart' show rlViewport;
export 'src/raylib.g.dart' show rlSetClipPlanes;
export 'src/raylib.g.dart' show rlGetCullDistanceNear;
export 'src/raylib.g.dart' show rlGetCullDistanceFar;

// ── Vertex level operations ──────────────────────────────────────────────
export 'src/raylib.g.dart' show rlBegin;
export 'src/raylib.g.dart' show rlEnd;
export 'src/raylib.g.dart' show rlVertex2i;
export 'src/raylib.g.dart' show rlVertex2f;
export 'src/raylib.g.dart' show rlVertex3f;
export 'src/raylib.g.dart' show rlTexCoord2f;
export 'src/raylib.g.dart' show rlNormal3f;
export 'src/raylib.g.dart' show rlColor4ub;
export 'src/raylib.g.dart' show rlColor3f;
export 'src/raylib.g.dart' show rlColor4f;

// ── OpenGL style functions (Vertex buffers state) ────────────────────────
export 'src/raylib.g.dart' show rlEnableVertexArray;
export 'src/raylib.g.dart' show rlDisableVertexArray;
export 'src/raylib.g.dart' show rlEnableVertexBuffer;
export 'src/raylib.g.dart' show rlDisableVertexBuffer;
export 'src/raylib.g.dart' show rlEnableVertexBufferElement;
export 'src/raylib.g.dart' show rlDisableVertexBufferElement;
export 'src/raylib.g.dart' show rlEnableVertexAttribute;
export 'src/raylib.g.dart' show rlDisableVertexAttribute;
// rlEnableStatePointer   — not available (OpenGL 1.1 only)
// rlDisableStatePointer  — not available (OpenGL 1.1 only)

// ── OpenGL style functions (Textures state) ──────────────────────────────
export 'src/raylib.g.dart' show rlActiveTextureSlot;
export 'src/raylib.g.dart' show rlEnableTexture;
export 'src/raylib.g.dart' show rlDisableTexture;
export 'src/raylib.g.dart' show rlEnableTextureCubemap;
export 'src/raylib.g.dart' show rlDisableTextureCubemap;
export 'src/raylib.g.dart' show rlTextureParameters;
export 'src/raylib.g.dart' show rlCubemapParameters;

// ── OpenGL style functions (Shader state) ────────────────────────────────
export 'src/raylib.g.dart' show rlEnableShader;
export 'src/raylib.g.dart' show rlDisableShader;

// ── OpenGL style functions (Framebuffer state) ───────────────────────────
export 'src/raylib.g.dart' show rlEnableFramebuffer;
export 'src/raylib.g.dart' show rlDisableFramebuffer;
export 'src/raylib.g.dart' show rlGetActiveFramebuffer;
export 'src/raylib.g.dart' show rlActiveDrawBuffers;
export 'src/raylib.g.dart' show rlBlitFramebuffer;
export 'src/raylib.g.dart' show rlBindFramebuffer;

// ── OpenGL style functions (General render state) ────────────────────────
export 'src/raylib.g.dart' show rlEnableColorBlend;
export 'src/raylib.g.dart' show rlDisableColorBlend;
export 'src/raylib.g.dart' show rlEnableDepthTest;
export 'src/raylib.g.dart' show rlDisableDepthTest;
export 'src/raylib.g.dart' show rlEnableDepthMask;
export 'src/raylib.g.dart' show rlDisableDepthMask;
export 'src/raylib.g.dart' show rlEnableBackfaceCulling;
export 'src/raylib.g.dart' show rlDisableBackfaceCulling;
export 'src/raylib.g.dart' show rlColorMask;
export 'src/raylib.g.dart' show rlSetCullFace;
export 'src/raylib.g.dart' show rlEnableScissorTest;
export 'src/raylib.g.dart' show rlDisableScissorTest;
export 'src/raylib.g.dart' show rlScissor;
export 'src/raylib.g.dart' show rlEnableWireMode;
export 'src/raylib.g.dart' show rlEnablePointMode;
export 'src/raylib.g.dart' show rlDisableWireMode;
export 'src/raylib.g.dart' show rlSetLineWidth;
export 'src/raylib.g.dart' show rlGetLineWidth;
export 'src/raylib.g.dart' show rlEnableSmoothLines;
export 'src/raylib.g.dart' show rlDisableSmoothLines;
export 'src/raylib.g.dart' show rlEnableStereoRender;
export 'src/raylib.g.dart' show rlDisableStereoRender;
export 'src/raylib.g.dart' show rlIsStereoRenderEnabled;
export 'src/raylib.g.dart' show rlClearColor;
export 'src/raylib.g.dart' show rlClearScreenBuffers;
export 'src/raylib.g.dart' show rlCheckErrors;
export 'src/raylib.g.dart' show rlSetBlendMode;
export 'src/raylib.g.dart' show rlSetBlendFactors;
export 'src/raylib.g.dart' show rlSetBlendFactorsSeparate;

// ── rlgl initialization ─────────────────────────────────────────────────
export 'src/raylib.g.dart' show rlglInit;
export 'src/raylib.g.dart' show rlglClose;
// export 'src/raylib.g.dart' show rlLoadExtensions;      // Pointer<Void> loader
export 'src/raylib.g.dart' show rlGetVersion;
export 'src/raylib.g.dart' show rlSetFramebufferWidth;
export 'src/raylib.g.dart' show rlGetFramebufferWidth;
export 'src/raylib.g.dart' show rlSetFramebufferHeight;
export 'src/raylib.g.dart' show rlGetFramebufferHeight;
export 'src/raylib.g.dart' show rlGetTextureIdDefault;
export 'src/raylib.g.dart' show rlGetShaderIdDefault;
// export 'src/raylib.g.dart' show rlGetShaderLocsDefault; // → Pointer<Int>

// ── Render batch management ─────────────────────────────────────────────
// export 'src/raylib.g.dart' show rlLoadRenderBatch;      // rlRenderBatch
// export 'src/raylib.g.dart' show rlUnloadRenderBatch;     // rlRenderBatch
// export 'src/raylib.g.dart' show rlDrawRenderBatch;       // Pointer<rlRenderBatch>
// export 'src/raylib.g.dart' show rlSetRenderBatchActive;  // Pointer<rlRenderBatch>
export 'src/raylib.g.dart' show rlDrawRenderBatchActive;
export 'src/raylib.g.dart' show rlCheckRenderBatchLimit;
export 'src/raylib.g.dart' show rlSetTexture;

// ── Vertex buffers management ───────────────────────────────────────────
export 'src/raylib.g.dart' show rlLoadVertexArray;
// export 'src/raylib.g.dart' show rlLoadVertexBuffer;              // Pointer<Void>
// export 'src/raylib.g.dart' show rlLoadVertexBufferElement;       // Pointer<Void>
// export 'src/raylib.g.dart' show rlUpdateVertexBuffer;            // Pointer<Void>
// export 'src/raylib.g.dart' show rlUpdateVertexBufferElements;    // Pointer<Void>
export 'src/raylib.g.dart' show rlUnloadVertexArray;
export 'src/raylib.g.dart' show rlUnloadVertexBuffer;
export 'src/raylib.g.dart' show rlSetVertexAttribute;
export 'src/raylib.g.dart' show rlSetVertexAttributeDivisor;
// export 'src/raylib.g.dart' show rlSetVertexAttributeDefault;     // Pointer<Void>
export 'src/raylib.g.dart' show rlDrawVertexArray;
// export 'src/raylib.g.dart' show rlDrawVertexArrayElements;       // Pointer<Void>
export 'src/raylib.g.dart' show rlDrawVertexArrayInstanced;
// export 'src/raylib.g.dart' show rlDrawVertexArrayElementsInstanced; // Pointer<Void>

// ── Textures management ─────────────────────────────────────────────────
// export 'src/raylib.g.dart' show rlLoadTexture;           // Pointer<Void>
export 'src/raylib.g.dart' show rlLoadTextureDepth;
// export 'src/raylib.g.dart' show rlLoadTextureCubemap;    // Pointer<Void>
// export 'src/raylib.g.dart' show rlUpdateTexture;         // Pointer<Void>
// export 'src/raylib.g.dart' show rlGetGlTextureFormats;   // Pointer<UnsignedInt> out
// export 'src/raylib.g.dart' show rlGetPixelFormatName;    // → Pointer<Char>
export 'src/raylib.g.dart' show rlUnloadTexture;
// export 'src/raylib.g.dart' show rlGenTextureMipmaps;     // Pointer<Int> out
// export 'src/raylib.g.dart' show rlReadTexturePixels;     // → Pointer<Void>
// export 'src/raylib.g.dart' show rlReadScreenPixels;      // → Pointer<UnsignedChar>

// ── Framebuffer management ──────────────────────────────────────────────
export 'src/raylib.g.dart' show rlLoadFramebuffer;
export 'src/raylib.g.dart' show rlFramebufferAttach;
export 'src/raylib.g.dart' show rlFramebufferComplete;
export 'src/raylib.g.dart' show rlUnloadFramebuffer;

// ── Shaders management ──────────────────────────────────────────────────
// export 'src/raylib.g.dart' show rlLoadShaderCode;        // Pointer<Char> * 2
// export 'src/raylib.g.dart' show rlCompileShader;         // Pointer<Char>
export 'src/raylib.g.dart' show rlLoadShaderProgram;
export 'src/raylib.g.dart' show rlUnloadShaderProgram;
// export 'src/raylib.g.dart' show rlGetLocationUniform;    // Pointer<Char>
// export 'src/raylib.g.dart' show rlGetLocationAttrib;     // Pointer<Char>
// export 'src/raylib.g.dart' show rlSetUniform;            // Pointer<Void>
// export 'src/raylib.g.dart' show rlSetUniformMatrix;      // Matrix
// export 'src/raylib.g.dart' show rlSetUniformMatrices;    // Pointer<Matrix>
export 'src/raylib.g.dart' show rlSetUniformSampler;
// export 'src/raylib.g.dart' show rlSetShader;             // Pointer<Int>

// ── Compute shader management ───────────────────────────────────────────
export 'src/raylib.g.dart' show rlLoadComputeShaderProgram;
export 'src/raylib.g.dart' show rlComputeShaderDispatch;

// ── Shader buffer storage object management (SSBO) ──────────────────────
// export 'src/raylib.g.dart' show rlLoadShaderBuffer;      // Pointer<Void>
export 'src/raylib.g.dart' show rlUnloadShaderBuffer;
// export 'src/raylib.g.dart' show rlUpdateShaderBuffer;    // Pointer<Void>
export 'src/raylib.g.dart' show rlBindShaderBuffer;
// export 'src/raylib.g.dart' show rlReadShaderBuffer;      // Pointer<Void>
export 'src/raylib.g.dart' show rlCopyShaderBuffer;
export 'src/raylib.g.dart' show rlGetShaderBufferSize;

// ── Buffer management ───────────────────────────────────────────────────
export 'src/raylib.g.dart' show rlBindImageTexture;

// ── Matrix state management ─────────────────────────────────────────────
// export 'src/raylib.g.dart' show rlGetMatrixModelview;            // → Matrix
// export 'src/raylib.g.dart' show rlGetMatrixProjection;           // → Matrix
// export 'src/raylib.g.dart' show rlGetMatrixTransform;            // → Matrix
// export 'src/raylib.g.dart' show rlGetMatrixProjectionStereo;     // → Matrix
// export 'src/raylib.g.dart' show rlGetMatrixViewOffsetStereo;     // → Matrix
// export 'src/raylib.g.dart' show rlSetMatrixProjection;           // Matrix
// export 'src/raylib.g.dart' show rlSetMatrixModelview;            // Matrix
// export 'src/raylib.g.dart' show rlSetMatrixProjectionStereo;     // Matrix * 2
// export 'src/raylib.g.dart' show rlSetMatrixViewOffsetStereo;     // Matrix * 2

// ── Quick and dirty cube/quad buffers ───────────────────────────────────
export 'src/raylib.g.dart' show rlLoadDrawCube;
export 'src/raylib.g.dart' show rlLoadDrawQuad;
