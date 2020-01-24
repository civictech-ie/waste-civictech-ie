<script>
	import { fade } from 'svelte/transition';
  import ResultsPane from './ResultsPane.svelte';

  export let focused;
  export let query;

  const prepopulatedQuery = query;
  let streets = [];
  let selectionIndex = 0;

  $: queryHasChanged = (query !== prepopulatedQuery)
  $: anyResults = !!streets.length;
  $: anyQuery = ((query.length) && (query.length > 1))
  $: updateSelection(selectionIndex, streets)
  $: updateStreets(query)

	function keyUpHandler(e) {
		if ((e.keyCode == 39) || (e.keyCode == 40)) {
      // right or down
      if ((selectionIndex + 1)< streets.length) {
        selectionIndex += 1;
      }
    } else if ((e.keyCode == 37) || (e.keyCode == 38)) {
      //left or up
      if (selectionIndex > 0) {
        selectionIndex -= 1;
      }
		} else if (e.keyCode == 13) {
      const street = streets[selectionIndex];
      window.location.href = `/streets/${street.slug}`;
		}
  }

  function updateSelection(i,s) {
    if (anyResults) {
      streets.forEach(function(street) {
        street.selected = false;
      });

      streets[i].selected = true;
    }
  }

  function updateStreets(q) {
    if (anyQuery && queryHasChanged) {
      fetchSearchResults(q)
        .then(data => {
          streets = data;
          selectionIndex = 0;
        })
        .catch(err => console.log('Ooops, error', err.message));
    } else {
      anyResults = false;
    }
  }

  async function fetchSearchResults(q) {
		const res = await fetch(`/api/v1/streets/search?q=${q}`, {
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
  .search-results {
  }

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

<svelte:window on:keyup={keyUpHandler} />

{#if focused && queryHasChanged}
  <ResultsPane>
    {#if anyResults}
      <ul class="search-results">
        {#each streets as { selected, name, postcode, slug }, i}
          <li transition:fade>
            <a href="/streets/{slug}" class="search-result" class:selected={selected}>
              <h3>{name}</h3>
              <p>Dublin {postcode}</p>
            </a>
          </li>
        {/each}
      </ul>
    {:else}
      <div class="empty-state">
        {#if anyQuery}
          <p>No results</p>
        {:else}
          <p>· · ·</p>
        {/if}
      </div>
    {/if}
  </ResultsPane>
{/if}
