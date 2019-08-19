<script>
  import SearchResults from './SearchResults.svelte';

  export let query;

  let focused = false;
</script>

<style>
  .search {
    position: relative;
  }
</style>

<div class="search">
  <form class="search-form" on:submit|preventDefault>
    <input
      type="text"
      name="query"
      placeholder="Start typing the name of your street&hellip;"
      bind:value={query}
      on:focus="{e => focused = true}"
      />
  </form>

  <SearchResults {query} {focused} />
</div>