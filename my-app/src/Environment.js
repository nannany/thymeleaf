import * as React from "react";

export class Environment extends React.Component {
  constructor(props) {
    super(props);
    this.getMetaData = this.getMetaData.bind(this);
    this.getMetaData1 = this.getMetaData1.bind(this);
  }

  getMetaData() {
    const fromEnvironment = document.getElementsByName(
      "from-environment"
    )[0].content;

    return fromEnvironment === '' ? process.env.REACT_APP_LOCAL_SUBSTITUTE : fromEnvironment;
  }

  getMetaData1() {
    return document.getElementsByName("test")[0].content;
  }

  render() {
    return (
      <div>
        <div>{this.getMetaData()}</div>
        <div>{this.getMetaData1()}</div>
      </div>
    );
  }
}
