import React from "react";
import PropTypes from "prop-types";
import CodeBlock from "@theme/CodeBlock";
import "./DocuCode.scss";

type AnnotatedCode = {
  color?: string;
  code: string;
};

const DocuCode = ({ children, annotations, title }) => {
  const code = children as string;
  const fullAnnotations = new Array<AnnotatedCode>();

  let annotationOffset = 0;
  for (var codeOffset = 0; codeOffset < code.length; ) {
    if (annotationOffset >= annotations.length) {
      // Out of annotations, just add the rest of the code
      fullAnnotations.push({ code: code.substring(codeOffset) });
      break;
    }

    const annotation = annotations[annotationOffset];
    if (codeOffset < annotation.offset) {
      /// There is an unannotated gap between the last annotation and this one.
      const codeLength = annotation.offset - codeOffset;
      fullAnnotations.push({
        code: code.substring(codeOffset, codeOffset + codeLength),
      });
      codeOffset += codeLength;
    }

    if (annotation.offset >= code.length) {
      throw new Error("Annotation offset out of bounds");
    }

    annotationOffset++;
    codeOffset = annotation.offset + annotation.length;
    fullAnnotations.push({
      color: annotation.color,
      code: code.substring(
        annotation.offset,
        annotation.offset + annotation.length
      ),
    });
  }

  const underlinesClassName = title ? "underlines has-title" : "underlines";

  return (
    <div className="docu-code">
      <span className="code">
        <code className={underlinesClassName}>
          {fullAnnotations.map(({ code, color }) => {
            let underlineClass = color ? `underline` : "";
            let style = color ? { textDecorationColor: color } : undefined;

            return (
              <span key={code} className={underlineClass} style={style}>
                {code}
              </span>
            );
          })}
        </code>
        <CodeBlock title={title}>{code}</CodeBlock>
      </span>
      <div className="annotations">
        {annotations.map((annotation, index) => (
          <div key={index} className="annotation">
            <span
              className="underline"
              style={{ textDecorationColor: annotation.color }}
            >
              {index}){" "}
            </span>
            {annotation.description}
          </div>
        ))}
      </div>
    </div>
  );
};

DocuCode.propTypes = {
  children: PropTypes.string.isRequired,
  annotations: PropTypes.arrayOf(
    PropTypes.shape({
      offset: PropTypes.number.isRequired,
      length: PropTypes.number.isRequired,
      color: PropTypes.string.isRequired,
      description: PropTypes.string.isRequired,
    })
  ).isRequired,
};

export default DocuCode;
