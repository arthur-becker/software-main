import { v4 as uuidv4 } from 'uuid';

export class EmptyIntervention {
  constructor() {
    this.id = uuidv4();
    this.name = '';
    this.description = '';
    this.tagIds = [];
    this.contents = [];
    this.isEmptyIntervention = true;
  }
}

export class Intervention {
  constructor({
    id, name, description, tagIds, contents,
  }) {
    this.id = id ?? uuidv4();
    this.name = name ?? '';
    this.description = description ?? '';
    this.tagIds = tagIds ?? [];
    this.contents = contents ?? [];
    this.isEmptyIntervention = false;
  }
}

// Mock API calls
export const postNewIntervention = async (interventionDraft) => interventionDraft;
export const putIntervention = async (interventionDraft) => interventionDraft;
export const deleteIntervention = async () => ({ errors: [] });
