import { v4 as uuidv4 } from 'uuid';

export class EmptyLevel {
  constructor() {
    this.levelId = uuidv4();
    this.name = '';
    this.description = '';
    this.upperLevelId = null;
    this.tagIds = [];
    this.allowedInterventions = [];
  }
}

export class Level {
  constructor({
    levelId, name, upperLevelId, tagIds, allowedInterventions, description,
  }) {
    this.levelId = levelId ?? uuidv4();
    this.name = name;
    this.description = description;
    this.upperLevelId = upperLevelId;
    this.tagIds = tagIds;
    this.allowedInterventions = allowedInterventions;
  }
}

// Mock API calls
export const postNewLevel = async (levelDraft) => levelDraft;
export const putLevel = async (levelDraft) => levelDraft;
export const deleteLevel = async () => ({ errors: [] });
