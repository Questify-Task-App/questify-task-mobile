
export type BaseItem = {
  id: string;
  text: string;
};

export type Daily = BaseItem & {
  done: boolean;
  cost: number;
};

export type Task = BaseItem & {
  completed: boolean;
  cost: number;
};

export type Reward = BaseItem & {
  cost: number;
  bought: boolean;
};

export type CoinsActionsProps = {
    coins: number;
    setCoins: (coins: number) => void;
};

export enum ListTypeEnum {
  Task = 'task',
  Daily = 'daily',
  Reward = 'reward',
}

export interface ListManagerProps {
  items: (Task | Reward | Daily)[];
  addItem: (text: string, cost: number) => void;
  deleteItem: (id: string) => void;
  editItem: (id: string, text: string, cost: number) => void;
  completeItem?: (id: string) => void;
  listType: ListTypeEnum;
}

export interface CoinBannerProps {
  coins: number
}

export interface ListFormProps {
  inputText: string;
  inputCost: string;
  addItem: (text: string, cost: number) => void;
};

export interface CoinsContextType {
  coins: number;
  setCoins: (value: number) => void;
}