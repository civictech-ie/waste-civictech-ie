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
  .empty-state {
    width: 100%;
    min-height: 12rem;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
  }

  .empty-state p {
    display: flex;
    background: rgba(0,0,0,0.125);
    padding: 0.5rem 2rem;
    border-radius: 2rem;
  }
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
  {#if query}
    <div class="empty-state">
      <p>No results</p>
    </div>
  {:else}
    <div class="empty-state">
      <p>No query</p>
    </div>
  {/if}
{/if}