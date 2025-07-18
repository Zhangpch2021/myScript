import tensorflow as tf
import numpy as np

# 定义异或(XOR)的输入和输出数据
x_train = np.array([[0, 0], [0, 1], [1, 0], [1, 1]], dtype=np.float32)
y_train = np.array([[0], [1], [1], [0]], dtype=np.float32)

# 构建神经网络模型
model = tf.keras.Sequential([
    tf.keras.layers.Dense(2, activation='sigmoid', input_shape=(2,)),  # 隐藏层
    tf.keras.layers.Dense(1, activation='sigmoid')                       # 输出层
])

# 编译模型
model.compile(
    optimizer=tf.keras.optimizers.Adam(learning_rate=0.1),
    loss='binary_crossentropy',
    metrics=['accuracy']
)

# 训练模型
history = model.fit(
    x_train, y_train,
    epochs=1000,
    verbose=0  # 设置为0以关闭训练过程输出
)

# 评估模型
_, accuracy = model.evaluate(x_train, y_train, verbose=0)
print(f"模型准确率: {accuracy * 100:.2f}%")

# 打印预测结果
predictions = model.predict(x_train)
print("\n预测结果:")
for i in range(len(x_train)):
    print(f"输入: {x_train[i]}, 目标输出: {y_train[i][0]}, 模型预测: {predictions[i][0]:.4f}")