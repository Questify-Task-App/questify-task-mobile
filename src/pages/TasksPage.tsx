import { View } from 'react-native';
import CoinBanner from '../components/CoinBanner';
import ListManager from '../components/ListManager';
import { usePersistentCoins } from '../hooks/usePersistentCoins';
import { usePersistentList } from '../hooks/usePersistentList';
import { globalStyles } from '../styles/GlobalStyles';
import { ListTypeEnum, Task } from '../types/itemTypes';

const TasksPage = () => {
    const { items: tasks, addItem, updateItem, deleteItem } = usePersistentList<Task>(ListTypeEnum.Task);
    const { coins, setCoins } = usePersistentCoins();

    const handleAdd = (text: string, cost: number) => {
        addItem({ id: Date.now().toString(), text, completed: false, cost: cost });
    };

    const handleEdit = (id: string, text: string, cost: number) => {
        updateItem(id, { text, cost });
    };

    const handleComplete = (id: string) => {
        const task = tasks.find((task) => task.id === id);
        if (task) {
            setCoins(coins + task.cost);
            deleteItem(task.id);
        } else {
            alert('The task you are trying to complete does not exist.');
        }
    };

    return (
        <View style={globalStyles.container}>
            <CoinBanner coins={coins} />
            <ListManager
                items={tasks}
                addItem={handleAdd}
                deleteItem={deleteItem}
                editItem={handleEdit}
                completeItem={handleComplete}
                listType={ListTypeEnum.Task}
            />
        </View>
    );
};

export default TasksPage;
