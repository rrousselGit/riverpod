import raw from "!!raw-loader!./raw.dart";
import hooks from "!!raw-loader!./hooks.dart";

export default {
  raw,
  hooks: hooks,
  codegen: raw,
  hooksCodegen: hooks,
};
