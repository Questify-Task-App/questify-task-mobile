import { View } from 'react-native';
import CoinBanner from '../components/CoinBanner';
import ListManager from '../components/ListManager';
import { usePersistentCoins } from '../hooks/usePersistentCoins';
import { usePersistentList } from '../hooks/usePersistentList';
import { globalStyles } from '../styles/GlobalStyles';
import { Daily, ListTypeEnum } from '../types/itemTypes';

const DailyPage = () => {
    const { items, addItem, updateItem, deleteItem } = usePersistentList<Daily>(ListTypeEnum.Daily);
    const { coins, setCoins } = usePersistentCoins();

    const handleAdd = (text: string, cost: number) => {
        addItem({ id: Date.now().toString(), text, done: false, cost: cost });
    };

    const handleEdit = (id: string, text: string, cost: number) => {
        updateItem(id, { text, cost });
    };

    const handleComplete = (id: string) => {
        const item = items.find((task) => task.id === id);
        if (item) {
            setCoins(coins + item.cost);
        } else {
            alert('The item you are trying to complete does not exist.');
        }
    };

    return (
        <View style={globalStyles.container}>
            <CoinBanner coins={coins} />
            <ListManager
                items={items}
                deleteItem={deleteItem}
                addItem={handleAdd}
                editItem={handleEdit}
                completeItem={handleComplete}
                listType={ListTypeEnum.Task}
            />
        </View>
    );
};

export default DailyPage;
