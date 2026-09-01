<template>
  <span ref="el">{{ displayValue }}</span>
</template>

<script>
import { CountUp } from 'countup.js'

export default {
  name: 'CountUpNumber',
  props: {
    startVal: {
      type: Number,
      default: 0,
    },
    endVal: {
      type: Number,
      required: true,
    },
    duration: {
      type: Number,
      default: 2,
    },
    decimals: {
      type: Number,
      default: 0,
    },
  },
  data() {
    return {
      counter: null,
      displayValue: '0',
    }
  },
  watch: {
    endVal(val) {
      if (this.counter) {
        this.counter.update(val)
      }
    },
  },
  mounted() {
    this.counter = new CountUp(this.$refs.el, this.endVal, {
      startVal: this.startVal,
      duration: this.duration,
      decimalPlaces: this.decimals,
      separator: ',',
    })
    if (!this.counter.error) {
      this.counter.start()
    }
  },
  beforeUnmount() {
    this.counter = null
  },
}
</script>
