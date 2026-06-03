import PropTypes from "prop-types";
import React from "react";
import _ from "underscore";
import classNames from "classnames";

import "./switch.scss";

const Switch = ({
  className,
  checked,
  disabled,
  onLabel,
  offLabel,
  onChange,
}) => {
  const uid = _.uniqueId("switch-");

  return (
    <div className={classNames("switch", className)}>
      <input
        type="checkbox"
        className="switch-checkbox"
        checked={checked}
        disabled={disabled}
        onChange={onChange}
        id={uid}
      />
      <label className="switch__wrapper" htmlFor={uid}>
        <div className="switch__circle" />
        <div className="switch__text">{checked ? onLabel : offLabel}</div>
      </label>
    </div>
  );
};

Switch.propTypes = {
  className: PropTypes.string,
  checked: PropTypes.bool,
  disabled: PropTypes.bool,
  onLabel: PropTypes.node,
  offLabel: PropTypes.node,
  onChange: PropTypes.func,
};

Switch.defaultProps = {
  className: null,
  checked: false,
  disabled: false,
  onLabel: "on",
  offLabel: "off",
  onChange: null,
};

export default Switch;
