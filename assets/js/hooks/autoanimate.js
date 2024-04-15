import autoAnimate from "@formkit/auto-animate";

export default AutoAnimateHook = {
  mounted() {
    autoAnimate(this.el);
  },
};
