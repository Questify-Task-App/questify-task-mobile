import { useRef, useState } from 'react';
import { Button, FlatList, Text, TextInput, View } from 'react-native';
import { usePersistentCoins } from '../hooks/usePersistentCoins';
import { globalStyles } from '../styles/GlobalStyles';
import { ListManagerProps, ListTypeEnum } from '../types/itemTypes';

const ListManager: React.FC<ListManagerProps> = ({ items, addItem, deleteItem, editItem, completeItem, listType }) => {
	const [inputText, setInputText] = useState('');
	const [inputCost, setInputCost] = useState('')
	const [itemId, setItemId] = useState('')
	const { coins } = usePersistentCoins()
	const [formButtonLabel, setFormButtonLabel] = useState('Add')
	const inputCostRef = useRef<TextInput>(null);

	const getCompleteButtonTitle = () => {
		return listType === ListTypeEnum.Reward ? 'Buy' : 'Done';
	};

	const handleEdit = (itemId: string) => {
		const item = items.find((i) => i.id === itemId);
		if (item) {
			setInputText(item.text)
			setInputCost(String(item.cost))
			setItemId(itemId)
			setFormButtonLabel("Done")
		}
	}

	function isFormVerified() {
		return inputText.trim().length > 0 && inputCost.trim().length > 0 && !isNaN(Number(inputCost)) && Number(inputCost) > 0;
	}

	const handleAdd = () => {
		if (isFormVerified()) {
			if (formButtonLabel === "Add") {
				addItem(inputText, Number(inputCost))
			} else {
				editItem(itemId, inputText, Number(inputCost))
				setFormButtonLabel("Add")
			}
			setInputCost('')
			setInputText('')
		} else {
			alert("Preencha os dois campos corretamente")
		}
	}

	const isDisabled = (itemId: string) => {
		if (listType !== ListTypeEnum.Reward) return false
		const item = items.find((i) => i.id === itemId);
		if (item) {
			return item.cost > coins
		} else {
			return false
		}
	}

	return (
		<View style={globalStyles.listContainer}>
			<View style={{ flexDirection: 'row', alignItems: 'center', margin: 8 }}>
				<TextInput
					style={{ flex: 1, borderWidth: 1, marginRight: 8, padding: 4 }}
					placeholder="Description"
					value={inputText}
					onChangeText={setInputText}
					returnKeyType="next"
					onSubmitEditing={() => inputCostRef.current?.focus()}
				/>
				<TextInput
					ref={inputCostRef}
					style={{ width: 80, borderWidth: 1, marginRight: 8, padding: 4 }}
					placeholder="Cost"
					value={inputCost}
					onChangeText={setInputCost}
					keyboardType="numeric"
					returnKeyType="done"
					onSubmitEditing={handleAdd}
				/>
				<Button title={formButtonLabel} onPress={handleAdd} />
			</View>
			<FlatList
				data={items}
				keyExtractor={(item) => item.id}
				renderItem={({ item }) => (
					<View style={globalStyles.item}>
						<Text>
							{`${item.text} (${item.cost} coins)`}
						</Text>
						<View style={globalStyles.itemButtons}>
							{completeItem && (
								<Button
									disabled={isDisabled(item.id)}
									title={getCompleteButtonTitle()}
									onPress={() => completeItem(item.id)}
								/>
							)}
							<Button
								title="Edit"
								onPress={() => handleEdit(item.id)}
							/>
							<Button title="Delete" onPress={() => deleteItem(item.id)} />
						</View>
					</View>
				)}
			/>
		</View>
	);
};

export default ListManager;