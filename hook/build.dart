import 'package:code_assets/code_assets.dart';
import 'package:hooks/hooks.dart';
import 'package:native_toolchain_xmake/native_toolchain_xmake.dart';

void main(List<String> args) async {
  await build(args, (input, output) async {
    final xmakeBuilder = await XmakeBuilder.create(
      project: input.packageRoot.toFilePath(),
      packageName: 'raylib',
      codeConfig: input.config.code,
    );

    await xmakeBuilder.config();
    await xmakeBuilder.build(target: 'basic');
    final installedPath = await xmakeBuilder.install(target: 'basic');

    output.assets.code.add(
      CodeAsset(
        package: input.packageName,
        name: 'src/raylib.g.dart',
        file: .file(installedPath),
        linkMode: DynamicLoadingBundled(),
      ),
    );

    output.dependencies.add(input.packageRoot.resolve('xmake.lua'));
  });
}
