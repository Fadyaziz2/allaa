<template>
  <div class="card-sceleton shadow-sm">
    <div class="content">
      <div class="heading">
        <p class=""></p>
        <p class=""></p>
        <p class=""></p>
        <p class=""></p>
      </div>
      <div class="data ">
        <p class="shimmer"> </p>
        <p class="shimmer"> </p>
        <p class="shimmer"> </p>
        <p class="shimmer"> </p>
      </div>
      <div class="data" v-for="n in 5">
        <p class="shimmer"> </p>
        <p class="shimmer"> </p>
        <p class="shimmer"> </p>
        <p class="shimmer"> </p>
      </div>

    </div>
  </div>
</template>

<script>
    export default {
      name: "LoaderSpin"
    }
</script>

<style lang="scss">
  .card-sceleton {
    display: flex;
    align-items: center;
    justify-content: center;
    background-color:var(--base-color);
    border-radius: 10px;
    padding: 15px;
    gap: 15px;
    min-width: 97%;
    position: absolute;
    top: 20px;

  .content {
    flex: 2;
    .heading {
      display: flex;
      gap: 15px;
      margin-bottom: 10px;
      p {
        background-color: var(--select-items-hover-bg);
        border-radius: 3px;
        margin-bottom: 7px;
        padding: 15px;
        display: flex;
        position: relative;
        overflow: hidden;
        flex: 1;
        border: 1px solid #80808024;

      }
    }

    .data {
      display: flex;
      gap: 15px;
      border-bottom: 1px solid lightgrey;
      margin-bottom: 10px;
      padding-bottom: 3px;
      p {
        background-color:var(--card-color);
        border-radius: 4px;
        margin-bottom: 7px;
        height: 26px;
        display: flex;
        position: relative;
        overflow: hidden;
        flex: 1;
      }
    }
  }
}

  .shimmer {
    &::after {
      content:'';
      height: 100%;
      width: 100%;
      background-image: linear-gradient(to right, rgba(251, 251, 251, 0.33), var(--chips-bg) 29%, rgba(255, 255, 255, 0.41));
      animation: shimmer 3s linear infinite;
      position: absolute;
    }
  }

  @keyframes shimmer{
    0% {
      background-position: -550px -120px;
    }
    100% {
      background-position: 0;
    }
  }
</style>

