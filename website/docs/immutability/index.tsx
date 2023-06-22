import raw from "!!raw-loader!./raw.dart";
import codegen from "!!raw-loader!./codegen.dart";
import codegen_why_immutability_example from "!!raw-loader!./codegen_why_immutability_example.dart";

export default {
  raw,
  hooks: raw,
  codegen: [codegen, codegen_why_immutability_example],
  hooksCodegen: codegen,
};
