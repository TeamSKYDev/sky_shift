<template>
<v-app>
  <form @submit.prevent="createPrivateSchedule">
    <div v-if="errors.length != 0">
      <ul v-for="e in errors" :key="e">
        <li><font color="red">{{ e }}</font></li>
      </ul>
    </div>
    <div>
      <label>タイトル</label>
      <input v-model="private_schedule.title" type="text">
    </div>
    <div>
      <label>内容</label>
      <input v-model="private_schedule.content" type="text">
    </div>
    <div>
      <label>開始時間</label>
      <input v-model="private_schedule.start_time" type="date">
    </div>
    <div>
      <label>終了時間</label>
      <input v-model="private_schedule.end_time" type="date">
    </div>
    <button type="submit">登録</button>
  </form>
</v-app>
</template>

<script>
import axios from 'axios';

export default {
  data: function () {
    return {
      private_schedule: {
        title: '',
        content: '',
        start_time: '',
        end_time: ''
      },
      errors: ''
    }
  },
  methods: {
    createPrivateSchedule: function() {
      axios
        .post('/api/v1/private_schedules', this.private_schedule)
        .then(response => {
          let e = response.data;
          this.$router.push({ name: 'CalendarIndex' });
        })
        .catch(error => {
          console.error(error);
          if (error.response.data && error.response.data.errors) {
            this.errors = error.response.data.errors;
          }
        });
    }
  }
}
</script>

<style scoped>
</style>