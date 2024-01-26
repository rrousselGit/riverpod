import raw from "!!raw-loader!./raw.dart";
import codegen from "!!raw-loader!./add_listener.dart";

export default {
  raw,
  hooks: raw,
  codegen,
  hooksCodegen: codegen,
};
