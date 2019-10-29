<script>
  import SearchResults from './SearchResults.svelte';

  export let query;
  let searchResults;

  let focused = false;
</script>

<style>
  .search {
    position: relative;
  }

  .note {
    margin-bottom: 1rem;
    padding: 1rem;
    background-color: var(--faint-dark);
    border-radius: 0.325em;
  }

  .note p:last-child {
    margin-bottom: 0;
  }
</style>

<div class="search">
  {#if !query}
    <div class="note">
      <p>Properly disposing of household rubbish in Dublin can be surprisingly confusing. Enter your street below and we'll walk you through it.</p>  
    </div>
  {/if}

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