<template>
  <div id="app">
    <table>
      <tbody>
        <tr>
          <th>ID</th>
          <th>name</th>
        </tr>
        <tr v-for="s in stores" :key="s.id">
          <td>{{ s.id }}</td>
          <td>{{ s.name }}</td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  data: function () {
    return {
      stores: []
    }
  },
  mounted () {
    axios
      .get('/api/v1/stores.json')
      .then(response => (this.stores = response.data))
  }
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>