<template>
  <v-snackbar v-model="isFeedbackShown" :color="type" :timeout="duration" class="feedback-snackbar">
    <v-alert border="left" :type="type" class="feedback-alert" prominent>
      {{ text }}
    </v-alert>
  </v-snackbar>
</template>

<script>
import { mapGetters, mapMutations } from 'vuex';

export default {
  name: 'Feedback',
  computed: {
    ...mapGetters({
      type: 'FEEDBACK_UI/getType',
      text: 'FEEDBACK_UI/getText',
      isDisplayed: 'FEEDBACK_UI/getIsDisplayed',
      duration: 'FEEDBACK_UI/getDuration',
    }),
  },
  methods: {
    ...mapMutations({
      setIsDisplayed: 'FEEDBACK_UI/setIsDisplayed',
    }),
  },
  watch: {
    isDisplayed(newValue) {
      if (newValue) this.isFeedbackShown = true;
    },
    isFeedbackShown(newValue) {
      if (!newValue) this.setIsDisplayed({ newValue: false });
    },
  },
  data() {
    return {
      isFeedbackShown: false,
    };
  },
};
</script>

<style>
.feedback-alert {
  margin: 0 !important;
}

.feedback-snackbar > .v-snack__wrapper > .v-snack__content {
  padding: 0 0 !important;
}
</style>
