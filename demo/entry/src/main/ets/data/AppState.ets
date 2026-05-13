export interface BookCard {
  id: number;
  title: string;
  levelTag: string;
  description: string;
  totalWords: number;
  learnedWords: number;
  todayNew: number;
  todayReview: number;
  streakDays: number;
  progress: number;
  accentColor: string;
  softColor: string;
}

export interface LearningWord {
  id: number;
  bookId: number;
  bookTitle: string;
  word: string;
  phonetic: string;
  meaning: string;
  memoryTip: string;
  example: string;
  translation: string;
  answer: string;
  options: string[];
  difficulty: string;
}

export interface StudyRecord {
  day: string;
  bookTitle: string;
  newCount: number;
  reviewCount: number;
  correctRate: number;
  finishedWords: number;
  duration: string;
}

export interface UserProfile {
  nickname: string;
  dailyTarget: number;
  signature: string;
  selectedBookId: number;
  totalLearnedWords: number;
  streakDays: number;
  accuracyRate: number;
  reviewDue: number;
}

export const userProfile: UserProfile = {
  nickname: '',
  dailyTarget: 30,
  signature: '',
  selectedBookId: 1,
  totalLearnedWords: 0,
  streakDays: 0,
  accuracyRate: 0,
  reviewDue: 0
};
