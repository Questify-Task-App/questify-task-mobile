import { createContext, ReactNode, useContext, useEffect, useState } from 'react';
import { loadValue, saveValue } from '../services/storageService';
import { CoinsContextType } from '../types/itemTypes';

const COINS_KEY = 'coins';

const CoinsContext = createContext<CoinsContextType | undefined>(undefined);

export const CoinsProvider = ({ children }: { children: ReactNode }) => {
  const [coins, setCoinsState] = useState(0);

  useEffect(() => {
    loadValue<number>(COINS_KEY).then((value) => {
      if (value !== null) {
        setCoinsState(value);
      }
      console.log(value)
    });
  }, []);

  const setCoins = (value: number) => {
    setCoinsState(value);
    saveValue(COINS_KEY, value);
  };

  return (
    <CoinsContext.Provider value={{ coins, setCoins }}>
      {children}
    </CoinsContext.Provider>
  );
};

// Custom hook to access the context
export const usePersistentCoins = (): CoinsContextType => {
  const context = useContext(CoinsContext);
  if (!context) {
    throw new Error('useCoins must be used within a CoinsProvider');
  }
  return context;
};