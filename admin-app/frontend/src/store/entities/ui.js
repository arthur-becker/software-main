import Vue from 'vue';
import { EmptyEntity, Entity } from './utils';
import { modalModesDict } from '../constants';

const entitiesUI = {
  namespaced: true,
  state: () => ({
    entityDraft: new EmptyEntity(),

    entityIdInFocus: null,
    isEntityModalDisplayed: false,
    entityModalMode: modalModesDict.read,
    creatingEntityInLevelId: null,
  }),
  getters: {
    /* READ */
    getEntityDraft: ({ entityDraft }) => entityDraft,
    getEntityIdInFocus: ({ entityIdInFocus }) => entityIdInFocus,
    getIsEntityModalDisplayed: ({ isEntityModalDisplayed }) => isEntityModalDisplayed,
    getEntityModalMode: ({ entityModalMode }) => entityModalMode,
    getCreatingEntityInLevelId: ({ creatingEntityInLevelId }) => creatingEntityInLevelId,

    entityInFocus: (state, { getEntityIdInFocus }, rootState, rootGetters) => rootGetters['entitiesData/entityById']({
      entityId: getEntityIdInFocus,
    }) ?? null,
  },
  mutations: {
    /* CREATE, UPDATE, DELETE */
    setEntityDraft: (state, {
      entityId, name, description, levelId, upperEntityId, tagIds,
    }) => {
      state.entityDraft = new Entity({
        entityId,
        name,
        description,
        levelId,
        upperEntityId,
        tagIds,
      });
    },
    resetEntityDraft: (state) => {
      state.entityDraft = new EmptyEntity();
    },
    setEntityIdInFocus: (state, { newValue }) => {
      state.entityIdInFocus = newValue;
    },
    setIsEntityModalDisplayed: (state, { newValue }) => {
      state.isEntityModalDisplayed = newValue;
    },
    setEntityModalMode: (state, { newValue }) => {
      state.entityModalMode = newValue;
    },
    setCreatingEntityInLevelId: (state, { levelId }) => {
      state.creatingEntityInLevelId = levelId;
    },
  },
  actions: {
    readEntityHandler: ({ commit }, { entityId }) => {
      commit('setEntityModalMode', { newValue: modalModesDict.read });
      commit('setEntityIdInFocus', { newValue: entityId });
      commit('resetEntityDraft');
      commit('setIsEntityModalDisplayed', { newValue: true });
    },
    abortReadEntityHandler: async ({ commit }) => {
      commit('setIsEntityModalDisplayed', { newValue: false });
      await Vue.nextTick();
      commit('setEntityIdInFocus', { newValue: null });
    },
    newEntityHandler: ({ commit }) => {
      commit('setEntityModalMode', { newValue: modalModesDict.create });
      commit('setEntityIdInFocus', { newValue: null });
      commit('resetEntityDraft');
      commit('setIsEntityModalDisplayed', { newValue: true });
    },
    abortNewEntityHandler: async ({ commit }) => {
      commit('setIsEntityModalDisplayed', { newValue: false });
      await Vue.nextTick();
      commit('resetEntityDraft');
      commit('setCreatingEntityInLevelId', { levelId: null });
      commit('setEntityModalMode', { newValue: modalModesDict.read });
    },
    editEntityHandler: ({ commit, rootGetters }, { entityId }) => {
      commit('setEntityModalMode', { newValue: modalModesDict.edit });
      commit('setEntityIdInFocus', { newValue: entityId });
      const entity = rootGetters['entitiesData/entityById']({ entityId });
      commit('setEntityDraft', entity);
      commit('setIsEntityModalDisplayed', { newValue: true });
    },
    abortEditEntityHandler: async ({ commit }) => {
      await Vue.nextTick();
      commit('resetEntityDraft');
      commit('setEntityModalMode', { newValue: modalModesDict.read });
    },

    saveEntityHandler: async ({ dispatch, getters }) => {
      if (getters.getEntityModalMode === modalModesDict.read) return;
      const entityDraft = getters.getEntityDraft;
      console.log(JSON.stringify({ entityDraft }));
      if (getters.getEntityModalMode === modalModesDict.create) {
        // 1. POST this in the ./data.js
        // 2. Await the response DB object
        // 3. Put the response DB object to entities
        await dispatch('entitiesData/APIpostNewEntity', entityDraft, {
          root: true,
        });
        return;
      }
      if (getters.getEntityModalMode === modalModesDict.edit) {
        // 1. POST this in the ./data.js
        // 2. Await the response DB object
        // 3. Put the response DB object to entities
        await dispatch('entitiesData/APIputEntity', entityDraft, { root: true });
      }
    },
    deleteEntityHandler: async ({ dispatch, getters }) => {
      if (getters.getEntityModalMode === modalModesDict.read) return;
      if (getters.getEntityModalMode === modalModesDict.create) return;
      // 1. DELETE this in the ./data.js
      // 2. Await the response DB object
      // 3. Put the response DB object to entities
      await dispatch('entitiesData/APIdeleteEntity', getters.getEntityIdInFocus, {
        root: true,
      });
    },
  },
};

export default entitiesUI;