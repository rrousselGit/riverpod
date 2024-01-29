import raw from "!!raw-loader!./raw.dart";
import codegen from "!!raw-loader!./completed_todos.dart";

export default {
  raw,
  hooks: raw,
  codegen,
  hooksCodegen: codegen,
};
