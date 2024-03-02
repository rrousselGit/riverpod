import raw from "!!raw-loader!./raw.yaml";
import codegen from "!!raw-loader!./codegen.yaml";

export default {
  raw,
  hooks: raw,
  codegen,
  hooksCodegen: codegen,
};
