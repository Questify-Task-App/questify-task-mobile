import { Alert, View } from 'react-native';
import CoinBanner from '../components/CoinBanner';
import ListManager from '../components/ListManager';
import { usePersistentCoins } from '../hooks/usePersistentCoins';
import { usePersistentList } from '../hooks/usePersistentList';
import { globalStyles } from '../styles/GlobalStyles';
import { ListTypeEnum, Reward } from '../types/itemTypes';

const RewardsPage = () => {
    const { items: rewards, addItem, updateItem, deleteItem } = usePersistentList<Reward>(ListTypeEnum.Reward);
    const { coins, setCoins } = usePersistentCoins();

    const handleAdd = (text: string, cost: number) => {
        addItem({ id: Date.now().toString(), text, cost: cost, bought: false });
    };

    const handleEdit = (id: string, text: string, cost: number) => {
        updateItem(id, { text, cost });
    };

    const handleClaim = async (id: string) => {
        const reward = rewards.find((r) => r.id === id);
        if (reward && coins >= reward.cost) {
            const newCoins = coins - reward.cost;
            setCoins(newCoins);
            updateItem(id, { bought: true });
        } else {
            Alert.alert('Insufficient Coins', 'You do not have enough coins to claim this reward.');
        }
    };

    return (
        <View style={globalStyles.container}>
            <CoinBanner coins={coins} />
            <ListManager
                items={rewards}
                addItem={handleAdd}
                deleteItem={deleteItem}
                editItem={handleEdit}
                completeItem={handleClaim}
                listType={ListTypeEnum.Reward}
            />
        </View>
    );
};

export default RewardsPage;
