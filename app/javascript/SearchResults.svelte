<script>
  export let query;

  let streets = [];
  let selectionIndex = 0;

  $: anyResults = !!streets.length;

  $: updateSelection(selectionIndex, streets)

  $: updateStreets(query)

  function updateSelection(i, array) {
  }
  
  function updateStreets(q) {
    fetchSearchResults(q)
    .then(data => {
      streets = data;
      selectionIndex = 0;
    })
    .catch(err => console.log('Ooops, error', err.message));
  }

  async function fetchSearchResults(q) {
		const res = await fetch(`streets/search?q=${q}`, {
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      }
    }
    );

    if (!res.ok) {
      throw new Error(res.status);
    }

    const data = await res.json();
    return data;
  }
</script>

<style>
</style>

{#if anyResults}
  <ul>
    {#each streets as { name, postcode, slug }, i}
      <li>
        <a href="streets/{slug}" class="search-result">
          <h3>{name}</h3>
          <p>Dublin {postcode}</p>
        </a>
      </li>
    {/each}
  </ul>
{:else}
  <p>No results</p>
{/if}