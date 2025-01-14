<template>
  <div style="overflow-x: scroll; width: 100%">
    <h1 class="ml-8">{{ $t('organizationStructure.title') }}</h1>
    <div class="my-8 d-flex">
      <div
        v-for="(level, index) in levels"
        :key="level.id"
        class="column-wrapper px-16"
        :class="level.upperLevelId === null || 'dotted-left-border'"
      >
        <LevelColumnHeader
          :id="level.id"
          :allowedInterventions="level.allowedInterventions"
          :name="level.name"
        />
        <EntitiesColumn :levelId="level.id" :index="index" />
      </div>
      <div class="column-wrapper dotted-left-border d-flex align-center justify-center">
        <LevelModal v-if="showLevelModal" />
        <EntityModal v-if="showEntityModal" />
        <v-btn rounded x-large color="primary" @click="clickOnAddNewLevel">
          <v-icon class="mr-2"> mdi-plus </v-icon>
          {{ $t('organizationStructure.addNewLevel') }}
        </v-btn>
      </div>
    </div>
  </div>
</template>

<script>
import { mapGetters, mapActions } from 'vuex';

import LevelModal from '../components/organizationStructure/LevelModal.vue';
import EntityModal from '../components/organizationStructure/EntityModal.vue';
import EntitiesColumn from '../components/organizationStructure/EntitiesColumn.vue';
import LevelColumnHeader from '../components/organizationStructure/LevelColumnHeader.vue';
import { dataTypesDict } from '../store/constants';

export default {
  name: 'OrganizationStructure',
  components: {
    LevelModal,
    EntityModal,
    EntitiesColumn,
    LevelColumnHeader,
  },
  data() {
    return {
      showLevelModal: false,
      showEntityModal: false,
    };
  },
  computed: {
    ...mapGetters({
      levels: 'LEVEL_Data/sortedLevels',
      isLevelModalDisplayed: 'dataModal/getIsDisplayed',
      entityModalIsDisplayed: 'dataModal/getIsDisplayed',
    }),
  },
  watch: {
    isLevelModalDisplayed: 'destroyLevelModalAfterDelay',
    entityModalIsDisplayed: 'destroyEntityModalAfterDelay',
  },
  methods: {
    ...mapActions({
      newLevelHandler: 'dataModal/createData',
    }),
    clickOnAddNewLevel() {
      this.newLevelHandler({ dataType: dataTypesDict.level });
    },
    async destroyLevelModalAfterDelay(newValue) {
      // If closed, wait for 500, if still closed, destroy component instance
      if (newValue) {
        this.showLevelModal = true;
        return;
      }
      await new Promise((resolve) => setTimeout(resolve, 500));
      if (!this.isLevelModalDisplayed) this.showLevelModal = false;
    },
    async destroyEntityModalAfterDelay(newValue) {
      // If closed, wait for 500, if still closed, destroy component instance
      if (newValue) {
        this.showEntityModal = true;
        return;
      }
      await new Promise((resolve) => setTimeout(resolve, 500));
      if (!this.isLevelModalDisplayed) this.showLevelModal = false;
    },
  },
};
</script>

<style scoped>
.column-wrapper {
  min-width: 24rem;
}

.dotted-left-border {
  border-left: 4px rgb(0, 0, 0, 0.2) dotted;
}

.edit-level-icon {
  transform: translate(4px, -8px);
}
</style>
