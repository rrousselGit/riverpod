import raw from "!!raw-loader!./raw.dart";
import codegen from "!!raw-loader!./todo.dart";

export default {
  raw,
  hooks: raw,
  codegen,
  hooksCodegen: codegen,
};
