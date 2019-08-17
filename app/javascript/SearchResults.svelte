<script>
  export let query;

  $: searchResults = fetchSearchResults(query);

  async function fetchSearchResults(q) {
		const res = await fetch(`streets/search?q=${q}`, {
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      }
    });
		const json = await res.json();

		if (res.ok) {
			return json;
		} else {
			throw new Error('Error!');
		}
  }
</script>

<style>
</style>

{#await searchResults}
	<p>...waiting</p>
{:then streets}
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
{:catch error}
	<p style="color: red">{error.message}</p>
{/await}