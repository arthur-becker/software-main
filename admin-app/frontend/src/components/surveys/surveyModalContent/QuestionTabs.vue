<template>
  <v-tabs background-color="grey lighten-3" show-arrows centered center-active v-model="iQ">
    <!-- <v-tabs-slider color="primary"></v-tabs-slider> -->
    <draggable
      v-model="questions"
      @start="drag = true"
      @end="drag = false"
      class="d-flex"
      :move="handleDrag"
    >
      <v-tab v-for="(q, i) in questions" :key="i" :value="i">
        <v-icon v-if="i === nQuestions - 1" large> mdi-plus </v-icon>
        <v-badge v-else color="grey lighten-2" :content="i + 1" bottom overlap>
          <div>
            <div v-if="q.questionType === 'multipleChoice'">
              <v-icon> mdi-checkbox-outline </v-icon>
              <v-icon> mdi-checkbox-outline </v-icon>
              <v-icon> mdi-checkbox-blank-outline </v-icon>
            </div>
            <div v-else-if="q.questionType === 'singleChoice'">
              <v-icon> mdi-radiobox-marked </v-icon>
              <v-icon> mdi-radiobox-blank </v-icon>
              <v-icon> mdi-radiobox-blank </v-icon>
            </div>
            <v-icon v-else large>
              {{ questionTypesIconDict[q.questionType] }}
            </v-icon>
          </div>
        </v-badge>
      </v-tab>
    </draggable>
  </v-tabs>
</template>

<script>
import { mapGetters, mapMutations } from 'vuex';
import draggable from 'vuedraggable';
import { questionTypesIconDict } from '../../../store/constants';

export default {
  name: 'QuestionTabs',
  components: { draggable },
  data() {
    return {
      iQ: 0,
      questionTypesIconDict,
      drag: [],
    };
  },
  mounted() {
    this.iQ = Math.max(this.nQuestions - 1, 0);
  },
  watch: {
    iQ(newVal) {
      // update the index in state only if it is caused by iQ
      if (newVal !== this.iQuestions) this.setIQuestions({ payload: newVal });
    },
    iQuestions(newVal) {
      this.iQ = newVal;
    },
  },
  computed: {
    ...mapGetters({
      questions: 'QUESTION_UI/questionWithAnswersDrafts',
      iQuestions: 'QUESTION_UI/getIQuestions',
      nQuestions: 'QUESTION_UI/nQuestions',
    }),
    questions: {
      get() {
        return this.$store.getters['QUESTION_UI/questionWithAnswersDrafts'];
      },
      set(value) {
        this.$store.commit('QUESTION_UI/setQuestions', { payload: value }, { root: true });
      },
    },
  },
  methods: {
    ...mapMutations({
      setIQuestions: 'QUESTION_UI/setIQuestions',
    }),
    handleDrag(evt) {
      return (
        !evt.draggedContext.element?.isEmptyQuestion && !evt.relatedContext.element?.isEmptyQuestion
      );
    },
  },
};
</script>
