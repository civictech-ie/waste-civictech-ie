<script>
</script>

<style>
  div {
    background: red;
    position: absolute;
    left: 0;
    right: 0;
    min-height: 80vh;
    top: calc(100% + 1rem);
    z-index: 9999;
    background-color: var(--faint);
  }
</style>

<div>
  <slot></slot>
</div>