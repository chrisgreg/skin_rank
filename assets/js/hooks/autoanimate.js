import autoAnimate from "@formkit/auto-animate";

export default AutoAnimateHook = {
  mounted() {
    console.log(this.el);
    autoAnimate(this.el);
  },
};
