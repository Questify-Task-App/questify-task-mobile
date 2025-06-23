import { useEffect, useState } from 'react';
import { loadValue, saveValue } from '../services/storageService';
import { ListTypeEnum } from '../types/itemTypes';

export function usePersistentList<T>(storageKey: ListTypeEnum) {
  const [items, setItems] = useState<T[]>([]);

  useEffect(() => {
    loadValue<T[]>(storageKey).then((value) => {
      if (value !== null) {
        setItems(value);
      }
    });
  }, [storageKey]);

  const addItem = (item: T) => {
    const updated = [...items, item];
    setItems(updated);
    saveValue(storageKey, updated);
  };

  const updateItem = (id: string, changes: Partial<T>) => {
    const updated = items.map(item =>
      (item as any).id === id ? { ...item, ...changes } : item
    );
    setItems(updated);
    saveValue(storageKey, updated);
  };

  const deleteItem = (id: string) => {
    const updated = items.filter(item => (item as any).id !== id);
    setItems(updated);
    saveValue(storageKey, updated);
  };

  return { items, setItems, addItem, updateItem, deleteItem };
}
