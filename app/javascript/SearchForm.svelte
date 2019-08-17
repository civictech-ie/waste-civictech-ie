<script>
  import SearchResults from './SearchResults.svelte';

  let query = "";
</script>

<style>
</style>

<form class="search-form" on:submit|preventDefault>
  <input
    type="text"
    name="query"
    placeholder="Start typing the name of your street&hellip;"
    bind:value={query} />
</form>

<SearchResults {query} />