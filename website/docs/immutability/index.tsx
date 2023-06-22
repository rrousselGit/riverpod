import raw from "!!raw-loader!./raw.dart";
import codegen from "!!raw-loader!./codegen.dart";
import raw_why_immutability_example from "!!raw-loader!./raw_why_immutability_example.dart";
import codegen_why_immutability_example from "!!raw-loader!./codegen_why_immutability_example.dart";

export default {
  raw: [raw, raw_why_immutability_example],
  hooks: [raw, raw_why_immutability_example],
  codegen: [codegen, codegen_why_immutability_example],
  hooksCodegen: [codegen, codegen_why_immutability_example],
};
