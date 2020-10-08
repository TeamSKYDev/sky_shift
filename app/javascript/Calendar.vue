<template>
  <div>
    <v-sheet tile height="6vh" color="grey lighten-3" class="d-flex align-center">
      <v-btn icon @click="$refs.calendar.prev()">
        <v-icon>mdi-chevron-left</v-icon>
      </v-btn>
      <v-btn icon @click="$refs.calendar.next()">
        <v-icon>mdi-chevron-right</v-icon>
      </v-btn>
    </v-sheet>
    <v-sheet height="70vh">
      <v-calendar
        ref="calendar"
        v-model="value"
        :events="events"
        :event-color="getEventColor"
        locale="ja-jp"
        :day-format="(timestamp) => new Date(timestamp.date).getDate()"
        :month-format="(timestamp) => (new Date(timestamp.date).getMonth() + 1) + ' /'"
        @change="getEvents"
        @click:event="showEvent"
        @click:date="viewDay"
      ></v-calendar>
    </v-sheet>
    <table>
      <tbody>
        <tr>
          <th>ID</th>
          <th>name</th>
        </tr>
        <tr v-for="s in private_schedules" :key="s.id">
          <td>{{ s.id }}</td>
          <td>{{ s.title }}</td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script>

import axios from 'axios';

export default {
  data: () => ({
    events: [],
    private_schedules: [],
    value: '',
  }),
  created () {
      axios
      .get('/api/v1/private_schedules')
      .then(response => (
          response.data.forEach(p => {
            this.events.push({
                name: p.title,
                start: new Date(p.start_time),
                end: new Date(p.end_time),
                color: 'yellow',
                timed: true,
            })
        })
      ))
  },
  methods: {
    getEvents() {
        this.events.push({
            name: '会議',
            start: new Date('2020-10-03T01:00:00'),
            end: new Date('2020-10-03T02:00:00'),
            color: 'blue',
            timed: true,
        })
        
    
    },
    getEventColor(event) {
      return event.color;
    },
    showEvent({ event }) {
        alert(`clicked ${event.name}`);
    },
    viewDay({ date }) {
        alert(`date: ${date}`);
    },
  },
};
</script>